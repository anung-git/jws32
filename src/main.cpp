#include <Arduino.h>
#include "Rtc.h"
#include "Segmen.h"
// #include <WiFi.h>
#include "BluetoothSerial.h"

#if !defined(CONFIG_BT_ENABLED) || !defined(CONFIG_BLUEDROID_ENABLED)
#error Bluetooth is not enabled! Please run `make menuconfig` to and enable it
#endif

BluetoothSerial SerialBT;

#if CONFIG_FREERTOS_UNICORE
#define ARDUINO_RUNNING_CORE 0
#else
#define ARDUINO_RUNNING_CORE 1
#endif

#ifndef LED_BUILTIN
#define LED_BUILTIN 2
#endif

// define two tasks for Blink & AnalogRead
void TaskBlink(void *pvParameters);
void TaskDisplaySegment(void *pvParameters);
void TaskRtcEprom(void *pvParameters);

// SemaphoreHandle_t xMutex;
QueueHandle_t timeDisplay;
QueueHandle_t setTime;

// the setup function runs once when you press reset or power the board
void setup()
{

  // initialize serial communication at 115200 bits per second:
  // WiFi.softAP("jws_WiFi", "password");

  SerialBT.begin("ESP32test"); //Bluetooth device name
  // IPAddress IP = WiFi.softAPIP();
  Serial.begin(9600);

  // Serial.print("AP IP address: ");
  // Serial.println(IP);

  timeDisplay = xQueueCreate(2, sizeof(char[8]));
  if (timeDisplay == 0)
  {
    Serial.println("Failed to create the queue timeDisplay");
  }
  setTime = xQueueCreate(2, sizeof(char[8]));
  if (setTime == 0)
  {
    Serial.println("Failed to create the queue setTime");
  }

  // Now set up two tasks to run independently.
  xTaskCreatePinnedToCore(
      TaskBlink, "TaskBlink" // A name just for humans
      ,
      1024 // This stack size can be checked & adjusted by reading the Stack Highwater
      ,
      NULL, 2 // Priority, with 3 (configMAX_PRIORITIES - 1) being the highest, and 0 being the lowest.
      ,
      NULL, ARDUINO_RUNNING_CORE);
  // Now set up two tasks to run independently.
  xTaskCreatePinnedToCore(
      TaskDisplaySegment, "taskDisplaySegment", // A name just for humans
      4096,                                     // This stack size can be checked & adjusted by reading the Stack Highwater
      NULL, 2,                                  // Priority, with 3 (configMAX_PRIORITIES - 1) being the highest, and 0 being the lowest.
      NULL, 0);

  xTaskCreatePinnedToCore(
      TaskRtcEprom, "taskRtcEprom", 2048 // Stack size
      ,
      NULL, 2 // Priority
      ,
      NULL, ARDUINO_RUNNING_CORE);

  // xMutex = xSemaphoreCreateMutex();

  // Now the task scheduler, which takes over control of scheduling individual tasks, is automatically started.
}

void loop()
{
  // Empty. Things are done in Tasks.
}

/*--------------------------------------------------*/
/*---------------------- Tasks ---------------------*/
/*--------------------------------------------------*/

void TaskBlink(void *pvParameters) // This is a task.
{
  (void)pvParameters;

  vTaskDelay(2000);
  // char timeBuffer[8]={17,17,0,6,28,0,2,21};
  // xQueueSend(setTime, &timeBuffer, portMAX_DELAY);

  for (;;) // A Task shall never return or exit.
  {
    // if (xSemaphoreTake(xMutex, (TickType_t)0xFFFFFFFF) == 1)
    // {
    //   xSemaphoreGive(xMutex);
    // }
    if (SerialBT.available())
    {
      Serial.write(SerialBT.read());
    }
  }
}

void TaskDisplaySegment(void *pvParameters) // This is a task.
{
  (void)pvParameters;
  u_char timeBuffer[8];
  Segmen segmen = Segmen(26, 25, 27);
  vTaskDelay(100);
  for (;;) // A Task shall never return or exit.
  {
    // if (xSemaphoreTake(xMutex, (TickType_t)0xFFFFFFFF) == 1)
    // {
    //   xSemaphoreGive(xMutex);
    // }
    if (timeDisplay > 0)
    {
      if (xQueueReceive(timeDisplay, &timeBuffer, portMAX_DELAY))
      {
        segmen.ledToggle();
        Serial.print("Data Receve = ");
        for (int i = 0; i < 10; i++)
        {
          Serial.print(timeBuffer[i]);
          if (i == 7)
          {
            Serial.println();
            break;
          }
          Serial.print(',');
        }
        segmen.setTime(timeBuffer[0], timeBuffer[1]);
        segmen.loop();
      }

      // Serial.print("Data receve = ");
      // for (int i = 0; i < 10; i++)
      // {
      //   Serial.print(timeBuffer[i]);
      //   if (i == 7)
      //   {
      //     Serial.println();
      //     break;
      //   }
      //   Serial.print(',');
      // }
    }
  }
}

void TaskRtcEprom(void *pvParameters) // This is a task.
{
  (void)pvParameters;

  Rtc Jam = Rtc();
  unsigned char jam, menit, detik;
  unsigned char tanggal, bulan, hari;
  int tahun;
  u_char timeBuffer[8];
  vTaskDelay(100);

  // Jam.setTime(16, 31, 00);
  // Jam.setTanggal(27, 02, 2021);
  for (;;)
  {
    Jam.getTime(jam, menit, detik);
    Jam.getTanggal(hari, tanggal, bulan, tahun);

    timeBuffer[0] = jam;
    timeBuffer[1] = menit;
    timeBuffer[2] = detik;
    timeBuffer[3] = hari;
    timeBuffer[4] = tanggal;
    timeBuffer[5] = bulan;
    timeBuffer[6] = tahun / 100;
    timeBuffer[7] = tahun % 100;

    Serial.print("Data Send = ");
    for (int i = 0; i < 10; i++)
    {
      Serial.print(timeBuffer[i]);
      if (i == 7)
      {
        Serial.println();
        break;
      }
      Serial.print(',');
    }
    xQueueSend(timeDisplay, &timeBuffer, portMAX_DELAY);

    if (setTime != 0)
    {
      if (xQueueReceive(setTime, &timeBuffer, portMAX_DELAY))
      {

        jam = timeBuffer[0];
        menit = timeBuffer[1];
        detik = timeBuffer[2];
        hari = timeBuffer[3];
        tanggal = timeBuffer[4];
        bulan = timeBuffer[5];
        tahun = timeBuffer[6] * 100 + timeBuffer[7];

        Jam.setTime(jam, menit, detik);
        Jam.setTanggal(tanggal, bulan, tahun);
      }
    }

    vTaskDelay(500);
  }
}
#include <Arduino.h>
#include "Rtc.h"
#include "Segmen.h"
#include "PrayerTimes.h"
#include "DFRobotDFPlayerMini.h"
// #include <WiFi.h>
#include "BluetoothSerial.h"
#include <DMD32.h> //
#include "fonts/SystemFont5x7.h"
#include "fonts/Arial_black_16.h"
#include <inttypes.h>
// ID CPU
#define KEY 225215781318192
//Fire up the DMD library as dmd
#define DISPLAYS_ACROSS 4
#define DISPLAYS_DOWN 1

#if !defined(CONFIG_BT_ENABLED) || !defined(CONFIG_BLUEDROID_ENABLED)
#error Bluetooth is not enabled! Please run `make menuconfig` to and enable it
#endif

double times[sizeof(TimeName) / sizeof(char *)];

// class inisialisasi
BluetoothSerial SerialBT;
DFRobotDFPlayerMini myDFPlayer;
DMD dmd(DISPLAYS_ACROSS, DISPLAYS_DOWN);

//display segment dan running text = core 0
//selain itu core 1
#define DISPLAY_CORE 0

#if CONFIG_FREERTOS_UNICORE
#define ARDUINO_RUNNING_CORE 0
#else
#define ARDUINO_RUNNING_CORE 1
#endif

#ifndef LED_BUILTIN
#define LED_BUILTIN 2
#endif

// define two tasks for Blink & AnalogRead
void TaskAndroid(void *pvParameters);
void TaskDisplay(void *pvParameters);
void TaskMain(void *pvParameters);

// SemaphoreHandle_t xMutex;
QueueHandle_t timeDisplay;
// QueueHandle_t setTime;

// the setup function runs once when you press reset or power the board
void setup()
{
  // DFPlayer inisialisasi
  Serial1.begin(9600);
  myDFPlayer.begin(Serial1);
  myDFPlayer.volume(25); //Set volume . From 0 to 30
  myDFPlayer.play(1);    //Play the first mp3

  // WiFi.softAP("jws_WiFi", "password");
  // IPAddress IP = WiFi.softAPIP();
  // Serial.print("AP IP address: ");
  // Serial.println(IP);

  // bluetooth inisialisasi
  SerialBT.begin("Jws DacxtroniC"); //Bluetooth device name
  Serial.begin(9600);

  uint64_t chipid = ESP.getEfuseMac(); //The chip ID is essentially its MAC address(length: 6 bytes).
  Serial.print("ESP32 Chip ID = ");    //print High 2 bytes
  // printf("% PRIu64 \n",  chipid);
  printf("%" PRIu64 "\n", chipid);
  if (chipid == KEY)
  {
    Serial.println("KUNCI TERBUKA");
  }
  else
  {
    Serial.println("KUNCI TERTUTUP");
  }

  timeDisplay = xQueueCreate(2, sizeof(char[8]));
  if (timeDisplay == 0)
  {
    Serial.println("Failed to create the queue timeDisplay");
  }
  // setTime = xQueueCreate(2, sizeof(char[8]));
  // if (setTime == 0)
  // {
  //   Serial.println("Failed to create the queue setTime");
  // }

  // Now set up two tasks to run independently.
  xTaskCreatePinnedToCore(
      TaskAndroid, "taskAndroid", // A name just for humans
      1024,                       // This stack size can be checked & adjusted by reading the Stack Highwater
      NULL, 2,                    // Priority, with 3 (configMAX_PRIORITIES - 1) being the highest, and 0 being the lowest.
      NULL, ARDUINO_RUNNING_CORE);
  // Now set up two tasks to run independently.
  xTaskCreatePinnedToCore(
      TaskDisplay, "taskDisplay", // A name just for humans
      4096,                       // This stack size can be checked & adjusted by reading the Stack Highwater
      NULL, 2,                    // Priority, with 3 (configMAX_PRIORITIES - 1) being the highest, and 0 being the lowest.
      NULL, DISPLAY_CORE);
  xTaskCreatePinnedToCore(
      TaskMain, "taskMain", 2048, // Stack size
      NULL, 2,                    // Priority
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

void TaskAndroid(void *pvParameters) // This is a task.
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

void TaskDisplay(void *pvParameters) // This is a task.
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
        // Serial.print("Data Receve = ");
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
        segmen.setTime(timeBuffer[0], timeBuffer[1]);
        segmen.setTanggal(timeBuffer[4], timeBuffer[5], 2000 + timeBuffer[7]);

        if (timeBuffer[2] % 10 < 5)
        {
          segmen.displayNormal();
        }
        else
        {
          // Tampilkan hari ke segment
          segmen.setHari(timeBuffer[3]);
        }

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

void TaskMain(void *pvParameters) // This is a task.
{
  (void)pvParameters;

  Rtc Jam = Rtc();
  unsigned char jam, menit, detik;
  unsigned char tanggal, bulan, hari;
  int tahun;
  u_char timeBuffer[8];
  vTaskDelay(100);
  set_calc_method(ISNA);
  set_asr_method(Shafii);
  set_high_lats_adjust_method(AngleBased);
  set_fajr_angle(20);
  set_isha_angle(18);
  // Jam.setTime(16, 31, 00);
  // Jam.setTanggal(28, 02, 2021);
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

    // if (setTime != 0)
    // {
    //   if (xQueueReceive(setTime, &timeBuffer, portMAX_DELAY))
    //   {

    //     jam = timeBuffer[0];
    //     menit = timeBuffer[1];
    //     detik = timeBuffer[2];
    //     hari = timeBuffer[3];
    //     tanggal = timeBuffer[4];
    //     bulan = timeBuffer[5];
    //     tahun = timeBuffer[6] * 100 + timeBuffer[7];

    //     Jam.setTime(jam, menit, detik);
    //     Jam.setTanggal(tanggal, bulan, tahun);
    //   }
    // }

    //  CODE BACA JADWAL
    float lt = -7.803249;
    float bj = 110.3398251;
    unsigned char wkt = 7;
    int hours, minutes;

    get_prayer_times(tahun, bulan, tanggal, lt, bj, wkt, times);
    get_float_time_parts(times[0], hours, minutes);
    int waktuSubuh = (hours * 60) + minutes + 2;
    get_float_time_parts(times[2], hours, minutes);
    int waktuDzuhur = (hours * 60) + minutes + 2;
    get_float_time_parts(times[3], hours, minutes);
    int waktuAshar = (hours * 60) + minutes + 2;
    get_float_time_parts(times[5], hours, minutes);
    int waktuMaghrib = (hours * 60) + minutes + 2;
    get_float_time_parts(times[6], hours, minutes);
    int waktuIsya = (hours * 60) + minutes + 2;
    int waktuImsya = waktuSubuh - 10;
    //DFPlayer code
    const int tilawahSubuh = 10;
    const int tilawahDzuhur = 10;
    const int tilawahAshar = 10;
    const int tilawahMaghrib = 10;
    const int tilawahIsya = 10;
    const int tilawahJumat = 10;
    int playSubuh = waktuSubuh - tilawahSubuh;
    int playDzuhur = waktuDzuhur - tilawahDzuhur;
    int playJumat = waktuDzuhur - tilawahJumat;
    int playAshar = waktuAshar - tilawahAshar;
    int playMaghrib = waktuMaghrib - tilawahMaghrib;
    int playIsya = waktuSubuh - tilawahSubuh;
    int compare = (jam * 60) + menit;
    if (tilawahSubuh > 0 && compare == playSubuh)
    {
      myDFPlayer.randomAll();
    }
    else if (tilawahDzuhur > 0 && compare == playDzuhur)
    {
      if (hari != 5) //bukan jumat
      {
        myDFPlayer.randomAll();
      }
    }
    else if (tilawahJumat > 0 && compare == playJumat)
    {
      if (hari == 5) //hari jumat
      {
        myDFPlayer.randomAll();
      }
    }
    else if (tilawahAshar > 0 && compare == playAshar)
    {
      myDFPlayer.randomAll();
    }
    else if (tilawahMaghrib > 0 && compare == playMaghrib)
    {
      myDFPlayer.randomAll();
    }
    else if (tilawahIsya > 0 && compare == playIsya)
    {
      myDFPlayer.randomAll();
    }

    // ALARM SHOLAT CODE

    if (compare == waktuImsya)
    {
      /* code */
    }
    if (compare == waktuSubuh)
    {
      /* code */
    }
    if (compare == waktuDzuhur)
    {
      // jumat 5
      if (hari == 5)
      {
        /* JUMATAN */
      }
      else
      {
        /* DZUHUR */
      }
    }
    if (compare == waktuAshar)
    {
      /* code */
    }
    if (compare == waktuMaghrib)
    {
      /* code */
    }
    if (compare == waktuIsya)
    {
      /* code */
    }

    printf("Subuh = %d:%d\n", waktuSubuh / 60, waktuSubuh % 60);
    printf("Dzuhur = %d:%d\n", waktuDzuhur / 60, waktuDzuhur % 60);
    printf("Ashar = %d:%d\n", waktuAshar / 60, waktuAshar % 60);
    printf("Maghrib = %d:%d\n", waktuMaghrib / 60, waktuMaghrib % 60);
    printf("Isya = %d:%d\n", waktuIsya / 60, waktuIsya % 60);
    vTaskDelay(1000);
  }
}
//edit from KHS
// sudo chmod a+rw /dev/ttyUSB0
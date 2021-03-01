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

//  Freertos
// ID CPU
#define KEY 225215781318192
//Fire up the DMD library as dmd
#define DISPLAYS_ACROSS 4
#define DISPLAYS_DOWN 1
#define BUZER 13

#if !defined(CONFIG_BT_ENABLED) || !defined(CONFIG_BLUEDROID_ENABLED)
#error Bluetooth is not enabled! Please run `make menuconfig` to and enable it
#endif

double times[sizeof(TimeName) / sizeof(char *)];

// class inisialisasi
BluetoothSerial SerialBT;
DFRobotDFPlayerMini myDFPlayer;
DMD dmd(DISPLAYS_ACROSS, DISPLAYS_DOWN);
Rtc Jam = Rtc();

//display segment dan running text = core 0
//selain itu core 1
#define DISPLAY_CORE 0

#if CONFIG_FREERTOS_UNICORE
#define ARDUINO_RUNNING_CORE 0
#else
#define ARDUINO_RUNNING_CORE 1
#endif

// define two tasks for Blink & AnalogRead
void TaskAndroid(void *pvParameters);
void TaskDisplay(void *pvParameters);
void TaskMain(void *pvParameters);

SemaphoreHandle_t rtcMutex;
QueueHandle_t timeDisplay;
QueueHandle_t jadwalQue;
QueueHandle_t alarmQue;
// QueueHandle_t setTime;

// Global variable

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

  timeDisplay = xQueueCreate(1, sizeof(char[8]));
  jadwalQue = xQueueCreate(1, sizeof(int[7]));
  alarmQue = xQueueCreate(1, sizeof(uint8_t[1]));

  // imsya,subuh,suruq,dzuhur,ashar,maghrib,isya
  // if (timeDisplay == 0)
  // {
  //   Serial.println("Failed to create the queue timeDisplay");
  // }
  // setTime = xQueueCreate(2, sizeof(char[8]));
  // if (setTime == 0)
  // {
  //   Serial.println("Failed to create the queue setTime");
  // }

  // Now set up two tasks to run independently.
  xTaskCreatePinnedToCore(
      TaskAndroid, "taskAndroid", // A name just for humans
      2048,                       // This stack size can be checked & adjusted by reading the Stack Highwater
      NULL, 1,                    // Priority, with 3 (configMAX_PRIORITIES - 1) being the highest, and 0 being the lowest.
      NULL, ARDUINO_RUNNING_CORE);
  // Now set up two tasks to run independently.
  xTaskCreatePinnedToCore(
      TaskDisplay, "taskDisplay", // A name just for humans
      3000,                       // This stack size can be checked & adjusted by reading the Stack Highwater
      NULL, 1,                    // Priority, with 3 (configMAX_PRIORITIES - 1) being the highest, and 0 being the lowest.
      NULL, ARDUINO_RUNNING_CORE);
  xTaskCreatePinnedToCore(
      TaskMain, "taskMain", 3000, // Stack size
      NULL, 1,                    // Priority
      NULL, ARDUINO_RUNNING_CORE);

  rtcMutex = xSemaphoreCreateMutex();
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

  vTaskDelay(100);
  // char timeBuffer[8]={17,17,0,6,28,0,2,21};
  // xQueueSend(setTime, (void *)&timeBuffer, portMAX_DELAY);

  for (;;) // A Task shall never return or exit.
  {
    vTaskDelay(1000);
    // if (xSemaphoreTake(xMutex, (TickType_t)0xFFFFFFFF) == 1)
    // {
    //   xSemaphoreGive(xMutex);
    // }
    if (SerialBT.available())
    {
      Serial.write(SerialBT.read());
    }

    printf("Stak android = %d\n", uxTaskGetStackHighWaterMark(NULL));
    // printf("Heep android = %d\n", xPortGetFreeHeapSize());
  }
  vTaskDelete(NULL);
}

void TaskDisplay(void *pvParameters) // This is a task.
{
  (void)pvParameters;
  u_char timeBuffer[8];
  int jadwalBufer[7];
  Segmen segmen = Segmen(26, 25, 27);
  vTaskDelay(100);
  for (;;) // A Task shall never return or exit.
  {
    // if (xSemaphoreTake(xMutex, (TickType_t)0xFFFFFFFF) == 1)
    // {
    //   xSemaphoreGive(xMutex);
    // }

    if (xQueueReceive(timeDisplay, (void *)&timeBuffer, 0) == pdTRUE)
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
    }
    uint8_t alarmFlag;
    // ReceveDisplay Jadwal
    if (xQueueReceive(alarmQue, (void *)&alarmFlag, 0) == pdTRUE)
    {
      switch (alarmFlag)
      {
      case 0:
        segmen.displayOn();
        segmen.displayNormal();
        break;
      case 1:
        segmen.displayOff();
        break;
      case 2:
        segmen.displayImsya();
        break;
      case 4:
        segmen.displaySubuh();
        break;
      case 5:
        segmen.displayDzuhur();
        break;
      case 6:
        segmen.displayDzuhur();
        break;
      case 7:
        segmen.displayAshar();
        break;
      case 8:
        segmen.displayMaghrib();
        break;
      case 9:
        segmen.displayIsya();
        break;
      case 10:
        segmen.displayIqomah();
        break;
      }

      printf("alarm start %d \n", alarmFlag);
    }
    // ReceveDisplay Jadwal
    if (xQueueReceive(jadwalQue, &jadwalBufer, 0) == pdTRUE)
    {
      // jadwalBufer[0] = waktuImsya;
      // jadwalBufer[1] = waktuSubuh;
      // jadwalBufer[2] = waktuImsya;
      // jadwalBufer[3] = waktuDzuhur;
      // jadwalBufer[4] = waktuAshar;
      // jadwalBufer[5] = waktuMaghrib;
      // jadwalBufer[6] = waktuIsya;

      segmen.setImsya(jadwalBufer[0] / 60, jadwalBufer[0] % 60);
      segmen.setSubuh(jadwalBufer[1] / 60, jadwalBufer[1] % 60);
      segmen.setSuruq(jadwalBufer[2] / 60, jadwalBufer[2] % 60);
      segmen.setDzuhur(jadwalBufer[3] / 60, jadwalBufer[3] % 60);
      segmen.setAshar(jadwalBufer[4] / 60, jadwalBufer[4] % 60);
      segmen.setMaghrib(jadwalBufer[5] / 60, jadwalBufer[5] % 60);
      segmen.setIsya(jadwalBufer[6] / 60, jadwalBufer[6] % 60);
      printf("Stak display = %d\n", uxTaskGetStackHighWaterMark(NULL));
      // printf("Heep display = %d\n", xPortGetFreeHeapSize());
      // printf("Imsya = %d:%d\n", jadwalBufer[0] / 60, jadwalBufer[0] % 60);
      // printf("Subuh = %d:%d\n", jadwalBufer[1] / 60, jadwalBufer[1] % 60);
      // printf("Suruq = %d:%d\n", jadwalBufer[2] / 60, jadwalBufer[2] % 60);
      // printf("Dzuhur = %d:%d\n", jadwalBufer[3] / 60, jadwalBufer[3] % 60);
      // printf("Ashar = %d:%d\n", jadwalBufer[4] / 60, jadwalBufer[4] % 60);
      // printf("Maghrib = %d:%d\n", jadwalBufer[5] / 60, jadwalBufer[5] % 60);
      // printf("Isya = %d:%d\n", jadwalBufer[6] / 60, jadwalBufer[6] % 60);
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

void TaskMain(void *pvParameters) // This is a task.
{
  (void)pvParameters;

  unsigned char jam, menit, detik;
  unsigned char tanggal, bulan, hari;
  int tahun;
  int jadwalBufer[7];
  u_char timeBuffer[8];
  pinMode(BUZER, OUTPUT);
  // digitalWrite(BUZER, HIGH);
  vTaskDelay(700);
  digitalWrite(BUZER, LOW);
  set_calc_method(ISNA);
  set_asr_method(Shafii);
  set_high_lats_adjust_method(AngleBased);
  set_fajr_angle(20);
  set_isha_angle(18);
  Jam.setTime(18, 0, 0);
  // Jam.setTanggal(28, 02, 2021);

  //1392

  for (;;)
  {

    if (xSemaphoreTake(rtcMutex, (TickType_t)0xFFFFFFFF) == 1)
    {
      Jam.getTime(jam, menit, detik);
      Jam.getTanggal(hari, tanggal, bulan, tahun);
      xSemaphoreGive(rtcMutex);
    }

    timeBuffer[0] = jam;
    timeBuffer[1] = menit;
    timeBuffer[2] = detik;
    timeBuffer[3] = hari;
    timeBuffer[4] = tanggal;
    timeBuffer[5] = bulan;
    timeBuffer[6] = tahun / 100;
    timeBuffer[7] = tahun % 100;

    // Serial.print("Data Send = ");
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
    if (xQueueSend(timeDisplay, (void *)&timeBuffer, portMAX_DELAY) != pdTRUE)
    {
      Serial.println(" Quee time full");
      /* code */
    }

    // if (setTime != 0)
    // {
    //   if (xQueueReceive(setTime, (void *)&timeBuffer, portMAX_DELAY))
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
    get_float_time_parts(times[1], hours, minutes);
    int waktuSuruq = (hours * 60) + minutes + 2;
    get_float_time_parts(times[2], hours, minutes);
    int waktuDzuhur = (hours * 60) + minutes + 2;
    get_float_time_parts(times[3], hours, minutes);
    int waktuAshar = (hours * 60) + minutes + 2;
    get_float_time_parts(times[5], hours, minutes);
    int waktuMaghrib = (hours * 60) + minutes + 2;
    get_float_time_parts(times[6], hours, minutes);
    int waktuIsya = (hours * 60) + minutes + 2;
    int waktuImsya = waktuSubuh - 10;

    //Kirim Ke display
    jadwalBufer[0] = waktuImsya;
    jadwalBufer[1] = waktuSubuh;
    jadwalBufer[2] = waktuSuruq;
    jadwalBufer[3] = waktuDzuhur;
    jadwalBufer[4] = waktuAshar;
    jadwalBufer[5] = waktuMaghrib;
    jadwalBufer[6] = waktuIsya;

    if (xQueueSend(jadwalQue, (void *)&jadwalBufer, portMAX_DELAY) != pdTRUE)
    {
      Serial.println("Que Jadwal full");
    }

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
    uint8_t beep;
    uint8_t alarmFlag = 0;

    if (compare == waktuImsya)
    {
      alarmFlag = 2;
      // beep=5;
      /* code */
    }
    if (compare == waktuSubuh)
    {
      beep = 5;
      alarmFlag = 3;
      /* code */
    }
    if (compare == waktuSuruq)
    {
      beep = 5;
      alarmFlag = 4;
      /* code */
    }
    if (compare == waktuDzuhur)
    {
      beep = 5;
      // jumat 5
      if (hari == 5)
      {
        beep = 5;
        alarmFlag = 5;
        /* JUMATAN */
      }
      else
      {
        beep = 5;
        alarmFlag = 6;
        /* DZUHUR */
      }
    }
    if (compare == waktuAshar)
    {
      beep = 5;
      alarmFlag = 7;
      /* code */
    }
    if (compare == waktuMaghrib)
    {
      // beep = 5;
      alarmFlag = 8;
      /* code */
    }
    if (compare == waktuIsya)
    {
      beep = 5;
      alarmFlag = 9;
      /* code */
    }

    if (alarmFlag > 0)
    {
      int adzan = 10;
      int iqomahCountDown = 10 * 60;
      //CODE FOR ADZAN
      while (adzan--)
      {
        printf("adzan = %d \n", adzan);
        myDFPlayer.stop();
        xQueueOverwrite(alarmQue, (void *)&alarmFlag);
        // Kirim pesan ke display
        // if (xQueueSend(alarmQue,(void *) &alarmFlag, portMAX_DELAY) != pdTRUE)
        // {
        //   Serial.println("quee alarm full");
        // }

        //hidupkan Buzer
        if (beep)
        {
          beep--;
          // digitalWrite(BUZER, HIGH);
          vTaskDelay(500);
          digitalWrite(BUZER, LOW);
          vTaskDelay(500);
        }
        uint8_t blink = adzan % 2;
        xQueueOverwrite(alarmQue, (void *)&blink);
        vTaskDelay(500);
      }
      // CODE FOR IQOMAH
      while (iqomahCountDown)
      {
        printf("iqomah = %d \n", iqomahCountDown);
        alarmFlag = 10;
        iqomahCountDown--;
        timeBuffer[0] = iqomahCountDown / 60;
        timeBuffer[1] = iqomahCountDown % 60;

        xQueueOverwrite(timeDisplay, (void *)&timeBuffer);
        xQueueOverwrite(alarmQue, (void *)&alarmFlag);
        delay(500);
        alarmFlag = 0;
        xQueueOverwrite(alarmQue, (void *)&alarmFlag);
        delay(500);
      }
    }

    printf("Stak main = %d\n", uxTaskGetStackHighWaterMark(NULL));
    // printf("Heep main = %d\n", xPortGetFreeHeapSize());
    vTaskDelay(1000);
  }
}
//edit from KHS
// sudo chmod a+rw /dev/ttyUSB0
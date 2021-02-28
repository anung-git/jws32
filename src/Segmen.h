#ifndef Segmen_H_
#define Segmen_H_

// #include "Event.h"
#include <Arduino.h>

#define ka   65
#define kb   49
#define kd   97
#define ke   3
#define kf   23
#define kg   9
#define kh   53
#define ki   237
#define kj   225
#define kk   21
#define kl   179
#define km1  135
#define km2  141
#define kn   133
#define ko   129
#define kp   7
#define kq   13
#define kr   151
#define ks   25
#define kt   51
#define ku   161
#define ky   41
#define kw1  177
#define kw2  225
#define k_   255

// #include <avr/pgmspace.h>
    const unsigned char PROGMEM lookupKalender [232]={
      k_,ks,ke,kn,ki,kn,k_,k_,
      k_,ks,ke,kl,ka,ks,ka,k_,
      k_,k_,kr,ka,kb,ku,k_,k_,
      k_,kk,ka,km1,km2,ki,ks,k_,
      k_,kj,ku,km1,km2,ka,kt,k_,
      k_,ks,ka,kb,kt,ku,k_,k_,
      k_,k_,ka,kh,ka,kd,k_,k_,
      k_,ka,kl,ka,kr,km1,km2,k_,
      k_,k_,k_,ko,kn,k_,k_,k_,
      k_,k_,k_,ko,kf,kf,k_,k_,
      k_,ki,km1,km2,ks,ky,ka,k_,
      k_,k_,ks,ku,kb,ku,kh,k_,
      k_,k_,kd,ku,kh,ku,kr,k_,
      k_,k_,ka,ks,kh,ka,kr,k_,
      km1,km2,ka,kg,kh,kr,ki,kb,
      k_,k_,ki,ks,ky,ka,k_,k_,
      k_,ks,kt,ka,kn,kb,ky,k_,
      ki,kq,ko,km1,km2,ka,kh,k_,
      k_,k_,kk,ko,kt,ka,k_,k_,
      k_,kj,ka,kd,kw1,kw2,ka,kl,
      kt,ka,kr,kt,ki,kl,k_,237,
      kt,ka,kr,kt,ki,kl,k_,67,
      kt,ka,kr,kt,ki,kl,k_,73,
      kt,ka,kr,kt,ki,kl,k_,45,
      kt,ka,kr,kt,ki,kl,k_,25,
      kt,ka,kr,kt,ki,kl,k_,17,
      kk,kh,ku,kt,kb,ka,kh,k_,
      k_,k_,k_,k_,k_,k_,k_,k_
    };


class Segmen{
private:
    unsigned char alarm, displayTemp;
    uint16_t compare ;
    int data, sck, strobe;
    uint8_t state;
    unsigned char buffer[36];
    unsigned char dataJam[11]= {136 ,238 ,73 ,76 ,46 ,28 ,24 ,206 ,8 ,12 ,255};
    unsigned char dataKalender [11]=  {129 ,237 ,67 ,73 ,45 ,25 ,17 ,205 ,1 ,9 ,255};
    unsigned char dataJadwal [11]=  {129 ,237 ,67 ,73 ,45 ,25 ,17 ,205 ,1 ,9 ,255};
    unsigned char bagiSepuluh(unsigned char nilai);
    unsigned char sisaBagiSepuluh(unsigned char nilai);

    enum modeSegmen{
      modeNormal,
      modeOff,
      modeOn,
      modeImsya,
      modeSubuh,
      modeDzuhur,
      modeAshar,
      modeMaghrib,
      modeIsya,
      modeJamOff,
      modeMenitOff,
      modeTanggalOff,
      modeBualnOff,
      modeTahunOff,
      modeIqomah,
    };
public:
  enum tampilKalender {
      kalenderSenin=1 ,
      kalenderSelasa ,
      kalenderRabu ,
      kalenderKamis ,
      kalenderJumat ,
      kalenderSabtu ,
      kalenderAhad ,
      kalenderAlarmBeep ,
      kalenderOn ,
      kalenderOff ,
      kalenderImsya ,
      kalenderSubuh ,
      kalenderDzuhur ,
      kalenderAshar ,
      kalenderMagrib ,
      kalenderIsya ,
      kalenderStanbay ,
      kalenderIqomah ,
      kalenderSetKota ,
      kalenderJadwal ,
      kalenderTartil1 ,
      kalenderTartil2 ,
      kalenderTartil3 ,
      kalenderTartil4 ,
      kalenderTartil5 ,
      kalenderTartil6 ,
      kalenderKutbah ,
    };
    Segmen(uint8_t data, uint8_t sck, uint8_t strobe );
    void loop();
    void setTime(unsigned char jam,unsigned char menit) ;
    void setHari(unsigned char hari) ;
    void setTanggal(unsigned char tanggal,unsigned char bulan,int tahun) ;
    void setImsya(unsigned char jam,unsigned char menit) ;
    void setSubuh(unsigned char jam,unsigned char menit) ;
    void setSuruq(unsigned char jam,unsigned char menit) ;
    void setDzuhur(unsigned char jam,unsigned char menit) ;
    void setAshar(unsigned char jam,unsigned char menit) ;
    void setMaghrib(unsigned char jam,unsigned char menit) ;
    void setIsya(unsigned char jam,unsigned char menit) ;
    void displayImsya();
    void displaySubuh();
    void displayDzuhur();
    void displayAshar();
    void displayMaghrib();
    void displayIsya();
    void displayNormal();
    void displayJamOff();
    void displayMenitOff();
    void displayTanggalOff();
    void displayBualnOff();
    void displayTahunOff();
    void displayIqomah();
    void displayOff();
    void displayOn();
    void ledOff();
    void ledOn();
    void ledToggle();

    ~Segmen();
};
#endif

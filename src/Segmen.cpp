#include "Segmen.h"
// #include <avr/pgmspace.h>
#include <Arduino.h>

Segmen::Segmen(uint8_t data, uint8_t sck, uint8_t strobe ){
    pinMode(data,OUTPUT);
    pinMode(sck,OUTPUT);
    pinMode(strobe,OUTPUT);
    Segmen::data = data;
    Segmen::sck = sck;
    Segmen::strobe = strobe;
    Segmen::alarm = 0;

    for(unsigned char i=0;i<4;i++)Segmen::buffer[i]=dataJam[0];
    for(unsigned char i=4;i<12;i++)Segmen::buffer[i]=dataKalender[0];
    for(unsigned char i=12;i<36;i++)Segmen::buffer[i]=dataJadwal[0];
}
unsigned char Segmen::bagiSepuluh( unsigned char nilai ){
  return (nilai/10);
}
unsigned char Segmen::sisaBagiSepuluh( unsigned char nilai ){
  return (nilai%10);
}
void Segmen::setTime(unsigned char jam, unsigned char menit ){
    Segmen::buffer[0] = (Segmen::dataJam[bagiSepuluh(jam)]);
    Segmen::buffer[1] = (Segmen::dataJam[sisaBagiSepuluh(jam)]);
    Segmen::buffer[2] = (Segmen::dataJam[bagiSepuluh(menit)]);
    Segmen::buffer[3] = (Segmen::dataJam[sisaBagiSepuluh(menit)]);
    this->loop();
}

void Segmen::ledOff(){
    // Segmen::buffer[2]&=0xf7;
    this->state=0;
    this->loop();
}
void Segmen::ledOn(){
    // Segmen::buffer[2]|=0x08;
    this->state=1;
    this->loop();

}
void Segmen::ledToggle(){
    if (this->state==0){
        this->state=1;
    }
    else{
        this->state=0;
    }
    this->loop();
}

    // if (kedip.getEvent()){
    //     if (state==0){
    //         this->ledOn();
    //         state=1;
    //     }
    //     else{
    //         state=0;
    //         this->ledOff();
    //     }
    // }

void Segmen::setHari(unsigned char hari ){
    if(hari == 0xaa)hari = 28;
    for(unsigned char i = 0;i<8;i++ ){
        Segmen::buffer[i+4]  =  pgm_read_byte_near(lookupKalender+((hari-1)*8)+i);
    }
    this->loop();

}

void Segmen::setTanggal(unsigned char tanggal, unsigned char bulan, int tahun ){
    Segmen::buffer[4] = (Segmen::dataKalender[bagiSepuluh( tanggal)]);
    Segmen::buffer[5] = (Segmen::dataKalender[sisaBagiSepuluh( tanggal)]);
    Segmen::buffer[6] = 255-128;
    Segmen::buffer[7] = (Segmen::dataKalender[bagiSepuluh( bulan)]);
    Segmen::buffer[8] = (Segmen::dataKalender[sisaBagiSepuluh( bulan)]);
    Segmen::buffer[9] = 255-128;
    Segmen::buffer[10] = (Segmen::dataKalender[bagiSepuluh( tahun-2000)]);
    Segmen::buffer[11] = (Segmen::dataKalender[sisaBagiSepuluh( tahun-2000)]);
}

void Segmen::setImsya(unsigned char jam, unsigned char menit ){
    Segmen::buffer[12] = (Segmen::dataJadwal[bagiSepuluh( jam)]);
    Segmen::buffer[13] = (Segmen::dataJadwal[sisaBagiSepuluh( jam)]);
    Segmen::buffer[14] = (Segmen::dataJadwal[bagiSepuluh( menit)]);
    Segmen::buffer[15] = (Segmen::dataJadwal[sisaBagiSepuluh( menit)]);
}
void Segmen::setSubuh(unsigned char jam, unsigned char menit ){
    Segmen::buffer[16] = (Segmen::dataJadwal[bagiSepuluh( jam)]);
    Segmen::buffer[17] = (Segmen::dataJadwal[sisaBagiSepuluh( jam)]);
    Segmen::buffer[18] = (Segmen::dataJadwal[bagiSepuluh( menit)]);
    Segmen::buffer[19] = (Segmen::dataJadwal[sisaBagiSepuluh( menit)]);
}
void Segmen::setSuruq(unsigned char jam, unsigned char menit ){
    Segmen::buffer[16] = (Segmen::dataJadwal[bagiSepuluh( jam)]);
    Segmen::buffer[17] = (Segmen::dataJadwal[sisaBagiSepuluh( jam)]);
    Segmen::buffer[18] = (Segmen::dataJadwal[bagiSepuluh( menit)]);
    Segmen::buffer[19] = (Segmen::dataJadwal[sisaBagiSepuluh( menit)]);
}
void Segmen::setDzuhur(unsigned char jam, unsigned char menit ){
    Segmen::buffer[20] = (Segmen::dataJadwal[bagiSepuluh( jam)]);
    Segmen::buffer[21] = (Segmen::dataJadwal[sisaBagiSepuluh( jam)]);
    Segmen::buffer[22] = (Segmen::dataJadwal[bagiSepuluh( menit)]);
    Segmen::buffer[23] = (Segmen::dataJadwal[sisaBagiSepuluh( menit)]);
}
void Segmen::setAshar(unsigned char jam, unsigned char menit ){
    Segmen::buffer[24] = (Segmen::dataJadwal[bagiSepuluh( jam)]);
    Segmen::buffer[25] = (Segmen::dataJadwal[sisaBagiSepuluh( jam)]);
    Segmen::buffer[26] = (Segmen::dataJadwal[bagiSepuluh( menit)]);
    Segmen::buffer[27] = (Segmen::dataJadwal[sisaBagiSepuluh( menit)]);
}
void Segmen::setMaghrib(unsigned char jam, unsigned char menit ){
    Segmen::buffer[28] = (Segmen::dataJadwal[bagiSepuluh( jam)]);
    Segmen::buffer[29] = (Segmen::dataJadwal[sisaBagiSepuluh( jam)]);
    Segmen::buffer[30] = (Segmen::dataJadwal[bagiSepuluh( menit)]);
    Segmen::buffer[31] = (Segmen::dataJadwal[sisaBagiSepuluh( menit)]);
}

void Segmen::setIsya(unsigned char jam, unsigned char menit ){
    Segmen::buffer[32] = (Segmen::dataJadwal[bagiSepuluh( jam)]);
    Segmen::buffer[33] = (Segmen::dataJadwal[sisaBagiSepuluh( jam)]);
    Segmen::buffer[34] = (Segmen::dataJadwal[bagiSepuluh( menit)]);
    Segmen::buffer[35] = (Segmen::dataJadwal[sisaBagiSepuluh( menit)]);
}

void Segmen::displayNormal(){
    Segmen::alarm = Segmen::modeNormal;
    this->loop();
}
void Segmen::displayImsya(){
    Segmen::alarm = Segmen::modeImsya;
    this->loop();
    // Segmen::setHari(Segmen::kalenderImsya);
}
void Segmen::displaySubuh(){
    Segmen::alarm = Segmen::modeSubuh;
    this->loop();
    // Segmen::setHari(Segmen::kalenderSubuh);
}
void Segmen::displayDzuhur(){
    Segmen::alarm = Segmen::modeDzuhur;
    this->loop();
    // Segmen::setHari(Segmen::kalenderDzuhur);
}
void Segmen::displayAshar(){
    Segmen::alarm = Segmen::modeAshar;
    this->loop();
    // Segmen::setHari(Segmen::kalenderAshar);
}
void Segmen::displayMaghrib(){
    Segmen::alarm = Segmen::modeMaghrib;
    this->loop();
    // Segmen::setHari(Segmen::kalenderMagrib);
}
void Segmen::displayIsya(){
    Segmen::alarm = Segmen::modeIsya;
    this->loop();
    // Segmen::setHari(Segmen::kalenderIsya);
}
void Segmen::displayJamOff(){
    Segmen::alarm = Segmen::modeJamOff;
    this->loop();
}
void Segmen::displayMenitOff(){
    Segmen::alarm = Segmen::modeMenitOff;
    this->loop();
}
void Segmen::displayTanggalOff(){
    Segmen::alarm = Segmen::modeTanggalOff;
    this->loop();
}
void Segmen::displayBualnOff(){
    Segmen::alarm = Segmen::modeBualnOff;
    this->loop();
}
void Segmen::displayTahunOff(){
    Segmen::alarm = Segmen::modeTahunOff;
    this->loop();
}
void Segmen::displayIqomah(){
    Segmen::alarm = Segmen::modeIqomah;
    this->loop();
}
void Segmen::displayOff(){
    if (this->alarm != Segmen::modeOff)
    {
        this->displayTemp = this->alarm;
        Segmen::alarm = Segmen::modeOff;
    }
    this->loop();
}
void Segmen::displayOn(){
    if (this->alarm ==  Segmen::modeOff)
    {
        this->alarm = this->displayTemp;
        this->loop();
    }
}

void Segmen::loop( ){
    // Serial.print("mode = ");
    // Serial.println(Segmen::alarm);

    unsigned char j[36];
    uint16_t total_display ;    
    


    for (unsigned char i = 35; i < 36; i--) {

        j[i] = Segmen::buffer[i];

        if (Segmen::alarm == Segmen::modeIqomah){    //imsya
            if(i>11) j[i]=Segmen::dataJadwal[10];
        }
        if (Segmen::alarm == Segmen::modeImsya){    //imsya
            if(i>15) j[i]=Segmen::dataJadwal[10];
        }
        if (Segmen::alarm == Segmen::modeOff){    //modeOff;
            if(i>3) j[i]=Segmen::dataJadwal[10];
        }
        if (Segmen::alarm == Segmen::modeSubuh){       //subuh
            if( i>11 && i<16 ){
                j[i]=Segmen::dataJadwal[10];
            }
            if( i>19 ){
                j[i]=Segmen::dataJadwal[10];
            }
        }
        if (Segmen::alarm == Segmen::modeDzuhur){       //dzuhur
            if( i>11 && i<20 ){
                j[i]=Segmen::dataJadwal[10];
            }
            if( i>23 ){
                j[i]=Segmen::dataJadwal[10];
            }
        }
        if (Segmen::alarm == Segmen::modeAshar){       //ashar
            if( i>11 && i<24 ){
                j[i]=Segmen::dataJadwal[10];
            }
            if( i>27 ){
                j[i]=Segmen::dataJadwal[10];
            }
        }
        if (Segmen::alarm == Segmen::modeMaghrib){       //maghrib
            if( i>11 && i<28 ){
                j[i]=Segmen::dataJadwal[10];
            }
            if( i>31 ){
                j[i]=Segmen::dataJadwal[10];
            }
        }
        if (Segmen::alarm == Segmen::modeIsya){       //isya
            if( i>11 && i<32 ){
                j[i]=Segmen::dataJadwal[10];
            }
        }
        if (Segmen::alarm == Segmen::modeJamOff){       //jam off
            if( i<2 ){
                j[i]=Segmen::dataJadwal[10];
            }
        }

        if (Segmen::alarm == Segmen::modeMenitOff){       //menit off
            if( i > 1 && i < 4 ){
                j[i]=Segmen::dataJadwal[10];
            }
        }

        if (Segmen::alarm == Segmen::modeJamOff){       //jam off
            if( i>3 ){
                j[i]=Segmen::dataJadwal[10];
            }
        }
    }

    if (this->state ==1){
        j[2]|=0x08;
    }
    else{
        j[2]&=0xf7;        
    }
    
    
    total_display=0;
    for (uint8_t i = 0; i < 36 ; i++) total_display += j[i];
    if (this->compare != total_display){            
        // Serial.print("total display = ");
        // Serial.println(total_display);
        // Serial.print("compare = ");
        // Serial.println(compare);
        this->compare = total_display;
        digitalWrite(Segmen::strobe,LOW);
        for (uint8_t i = 35; i < 36; i--){
            // if (i==6 || i == 9)
            // {
            //     continue;
            // }       
            // if (i==10 || i == 11)
            // {
            //     continue;
            // }
            // shiftOut(Segmen::data,Segmen::sck,LSBFIRST,j[i]);
            for(unsigned char k = 0;k<8;k++ ){// shiftout
                if((j[i] & 0x80) == 0x80){
                    digitalWrite(Segmen::data,HIGH);
                }
                else {
                    digitalWrite(Segmen::data,LOW);
                }
                j[i] = (j[i]<<1)|(j[i]>>7);
                digitalWrite(Segmen::sck,HIGH);
                digitalWrite(Segmen::sck,LOW);
            }
        }
        digitalWrite(Segmen::strobe,HIGH);
    }
}
Segmen::~Segmen()
{
}

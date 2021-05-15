int input;  // 読み込み用変数

void setup(){
  Serial.begin(9600);
}

void loop(){
  input = analogRead(0);          // 読み込み
  Serial.write('H');              // Provessing側読み込み用の目印
  Serial.write(highByte(input));  // 上位バイトの送信
  Serial.write(lowByte(input));   // 下位バイトの送信
}

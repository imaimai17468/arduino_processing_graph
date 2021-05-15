import  processing.serial.*;

Serial serial;  // シリアルポート設定用変数
int[] data;     // 入力受け取り用配列
float[] border;   // 罫線の位置保持用配列

// グラフの周りの空白
final int left_padding = 200;
final int down_padding = 200;
final int right_padding = 100;
final int up_padding = 100;
final int valueH = 1024;

// 設定
void setup() {  
  size(1100, 800);                                       // 画面サイズの設定(200+800+100, 100+500+200)
  data = new int [width-right_padding-left_padding];     // データの最大幅をグラフの幅と同じにする
  border = new float [5];
  serial = new Serial( this, Serial.list()[0], 9600 );   // シリアルポートの設定
  
  for(int i = 0; i < 5; i++){
    border[i] = convToGraphPoint(200+i*200);
  }
}


// グラフ描画
void draw() {
  background(10);
  
  
  // グラフ罫線
  strokeWeight(1);
  stroke(100);
  // 横罫線
  for(int i = 0; i < 5; i++){
    line(left_padding, up_padding+border[i], width-right_padding, up_padding+border[i]);
  }
  
  
  strokeWeight(2);
  // グラフの枠線
  noFill();
  stroke(244);
  rect(left_padding, up_padding, width-left_padding-right_padding, height-up_padding-down_padding);
  
  stroke(0, 255, 0);


  //グラフの描画
  for (int i = 0; i < data.length-1; i++) {
    line( i+left_padding, convToGraphPoint(data[i])+up_padding, i+left_padding+1, convToGraphPoint(data[i+1])+up_padding);
  }
  // 上限確認用
  //line(i+left_padding, convToGraphPoint(valueH), i+left_padding+1, convToGraphPoint(valueH));
  
  
  // 縦軸メモリ
  stroke(0);
  fill(100);
  textSize((height-up_padding-down_padding)*0.06);
  textAlign(RIGHT);
  for(int i = 0; i < 6; i++){
    if(i == 5) text(0, left_padding-10, height-down_padding);
    else text(200*i+200, left_padding-10, up_padding+border[i]+10);
  }
  
  
  // 縦軸ラベル
  pushMatrix();
  rotate(radians(-90));
  textAlign(CENTER);
  text("input value", -(up_padding + (height-up_padding-down_padding)/2), left_padding-125);
  popMatrix();
  
  // 横軸ラベル
  text("step", left_padding + (width-left_padding-right_padding)/2, height-down_padding+50);
  
  
  // 現在の値
  textSize(50);
  text(data[data.length-1], width-right_padding, height-down_padding+150);
  textSize(25);
  text("now",width-right_padding-50, height-down_padding+100);
  
  // タイトル
  textSize(50);
  text("Real Time Graph", left_padding + (width-left_padding-right_padding)/2, up_padding-20);
}


// 受け取り用関数
void serialEvent(Serial port) {  
  if ( port.available() >= 3 ) {
    if ( port.read() == 'H' ) {
      int high = port.read();      
      int low = port.read();
      int recv_data = high*256 + low;
      println(recv_data);
      //時系列データを更新
      for (int i=0; i<data.length-1; i++) {
        data[i] = data[i+1];
      }
      data[data.length-1] = recv_data;
    }
  }
}


// 受け取った値をプロットする高さに直す
float convToGraphPoint(int value) {
  return ((height-down_padding-up_padding) - value*(height-down_padding-up_padding)/valueH);
}

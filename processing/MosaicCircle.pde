ArrayList<Bubble> bubbles; // Bubbleクラスを格納するArrayList
PImage img;
int maxSize = 60;

void setup(){
  size(800, 800);
  frameRate(60);
  noStroke();
  //ArrayListの初期化
  bubbles = new ArrayList<Bubble>();
  //画像を読み込んで画面の大きさにリサイズ
  img = loadImage("hara.jpg"); //好きな画像に変更してください。
  img.resize(width, height);
  //最初のきっかけの円を描画する
  for(int i = 0; i < 10; i++){
    PVector loc = new PVector(random(width), random(height));
    bubbles.add(new Bubble(loc));
  }
}

void draw(){
  background(0);
  //ArrayListに格納された数だけBubbleを描画
  for(int i = 0; i < bubbles.size(); i++){
    bubbles.get(i).draw();
  }
  //Bubbleの状態を確認
  for(int i = 0; i < bubbles.size(); i++){
    //もしアクティブな結果だったら
    if(bubbles.get(i).isDead == false){
      //円の周囲のピクセルの色を確認
      boolean expand = bubbles.get(i).checkPixel();
      //もしこれ以上膨張できない場合
      if(expand == false){
        //新規にBubbleを生成
        PVector loc;
        //余白が見つかるまで繰り返し
        while(true){
          loc = new PVector(random(width),random(height));
          color c = get(int(loc.x), int(loc.y));
          if((red(c) + blue(c) + green(c)) == 0) break;
        }
        //余白に新規Bubbleを生成
        bubbles.add(new Bubble(loc));
        bubbles.get(i).isDead = true;
      }
    }
  }
}

//マウスクリックで初期化
void mouseClicked(){
  // ArrayListをクリア
  bubbles.clear();
  //きっかけの円を描画
  for(int i = 0; i < 100; i++){
    PVector loc = new PVector(random(width), random(height));
    bubbles.add(new Bubble(loc));
  }
}

// Bubbleクラス
// 円が膨張しながら空間を重鎮していく
class Bubble{
  float size;
  float expandSpeed;
  color circleColor;
  PVector location;
  boolean expand;
  boolean isDead;
  
  //コンストラクタ
  Bubble(PVector _location){
    location = _location; // 位置を引数から取得
    //パラメータの初期値設定
    size = 0;
    expandSpeed = 4.0;
    expand = true;
    isDead = false;
    // 読み込んだ画像から中心位置と同じピクセルの色を取得
    circleColor = img.get(int(location.x), int(location.y));
  }
  
  //円を描画
  void draw(){
    if(expand == true){
      size += expandSpeed;
    }
    fill(circleColor);
    ellipse(location.x, location.y, size, size);
  }
  
  boolean checkPixel(){
    float nextSize = size + expandSpeed;
    for(float i = 0; i < TWO_PI; i += 0.01){
      int x = int(cos(i) * nextSize / 2.0 + location.x);
      int y = int(sin(i) * nextSize / 2.0 + location.y);
      color c = get(x, y);
      if((red(c) + blue(c) + green(c)) > 0 || size > maxSize){
        expand = false;
      }
    }
    return expand;
  }
}

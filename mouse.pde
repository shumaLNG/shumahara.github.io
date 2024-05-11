int NUM; // 球の数を格納する変数

// HTMLから球の数を取得
String numParticlesStr = select("#numParticles").value();
NUM = int(numParticlesStr);

ParticleVec3[] particles = new ParticleVec3[NUM];

void setup(){
  size(800, 600, P3D);
  frameRate(60);
  
  for(int i = 0; i < NUM; i++){
    particles[i] = new ParticleVec3();
    particles[i].location.set(random(width), random(height), random(height / 2));
    particles[i].gravity.set(0.0, 0.0, 0.0);
    particles[i].friction = 0.01;
    particles[i].radius = random(1, 5); // ランダムな大きさを設定する
  }
}

void draw(){
  background(0); // 背景を一度だけ描画する
  noStroke();
  fill(0, 31);
  rect(0, 0, width, height);
  
  for(int i = 0; i < NUM; i++){
    // パーティクルの色をランダムに設定する
    fill(random(255), random(255), random(255));
    
    particles[i].update();
    particles[i].draw();
    particles[i].bounceOffWalls();
  }
}

void mouseDragged(){
  for(int i = 0; i < NUM; i++){
    PVector mouseLoc = new PVector(mouseX, mouseY);
    particles[i].attract(mouseLoc, 200, 5, 20);
  }
}

class ParticleVec3 {
  PVector location;          // 位置
  PVector velocity;          // 速度
  PVector acceleration; // 加速度
  PVector gravity;           // 重力
  float mass;                     // 質量
  float friction;                 // 摩擦力
  PVector min;                 // 移動範囲 min
  PVector max;                // 移動範囲　max
  float radius;                   // パーティクル半径
  float G;                            // 重力定数
  
  // コンストラクタ
  ParticleVec3() {
    radius = 4.0;
    mass = 1.0;  // 質量は1.0
    friction = 0.01; // 摩擦力は0.01
    G = 1.0;   // 重力定数は１.０
    // 位置、速度、加速度を初期化
    location = new PVector(0.0, 0.0, 0.0);
    velocity = new PVector(0.0, 0.0, 0.0);
    acceleration = new PVector(0.0, 0.0, 0.0);
    gravity = new PVector(0.0, 0.0, 0.0); // 重力なし
    // 移動範囲を設定
    min = new PVector(0, 0, 0);
    max = new PVector(width, height, height / 2);
  }
  
   // 運動方程式から位置を更新
  void update() {
    acceleration.add(gravity); // 重力を加える
    velocity.add(acceleration); // 加速度から速度を算出する
    velocity.mult(1.0 - friction); // 摩擦力から速度を変化
    location.add(velocity); // 速度から位置を算出する
    acceleration.set(0, 0, 0); // 加速度を０にリセット（等速運動）する
  }
  
  // 描画する
  void draw() {
    pushMatrix();
    translate(location.x, location.y, location.z);
    ellipse(0, 0, mass * radius * 2, mass * radius * 2);
    popMatrix();
  }
  
  // 力を加える
  void addForce(PVector force){
     force.div(mass);
     acceleration.add(force);
   }
   
   // 引力の計算
   void attract(PVector center, float _mass, float min, float max){
     // 距離を算出する
     float distance = PVector.dist(center, location);
     // 距離を指定した範囲内に収める（極端な値を無視する）
     distance = constrain(distance, min, max);
     // 引力の強さを算出
     float strength = G * (mass * _mass) / (distance * distance);
     // 引力の中心点とパーティクル間のベクトルを作成
     PVector force = PVector.sub(center, location);
     // ベクトルを正規化
     force.normalize();
     // ベクトルに力の強さを乗算
     force.mult(strength);
     // 力を加える
     addForce(force);
   }
   
   void bounceOffWalls(){
     if(location.x > max.x){
      location.x = max.x;
      velocity.x *= -1;
    }
    if(location.x < min.x){
       location.x = min.x;
       velocity.x *= -1;
    }
    if(location.y > max.y){
        location.y = max.y;
        velocity.y *= -1;
    }
    if(location.y < min.y){
        location.y = min.y;
        velocity.y *= -1;
    }
     if(location.z > max.z){
       location.z = max.z;
       velocity.z *= -1;
    }
    if(location.z < min.z){
       location.z = min.z;
       velocity.z *= -1;
    }
   }
   
   // 壁を突き抜けて反対側から出現させる
   void throughWalls(){
    if(location.x > max.x){
      location.x = max.x;
    }
    if(location.x < min.x){
      location.x = min.x;
    }
    if(location.y > max.y){
      location.y = max.y;
    }
    if(location.y < min.y){
      location.y = min.y;
    }
    if(location.z > max.z){
      location.z = max.z;
    }
    if(location.z < min.z){
      location.z = min.z;
    }
  }
}

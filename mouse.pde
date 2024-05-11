int NUM; // 球の数を格納する変数

ParticleVec3[] particles; // ParticleVec3クラスのインスタンスを格納する配列

void setup() {
  size(800, 600, P3D);
  frameRate(60);

  // HTMLから球の数を取得
  String numParticlesStr = select("#numParticles").value();
  NUM = int(numParticlesStr);

  particles = new ParticleVec3[NUM]; // 球の数だけParticleVec3クラスのインスタンスを生成する

  for (int i = 0; i < NUM; i++) {
    particles[i] = new ParticleVec3();
    particles[i].location.set(random(width), random(height), random(height / 2));
    particles[i].gravity.set(0.0, 0.0, 0.0);
    particles[i].friction = 0.01;
    particles[i].radius = random(1, 5);
  }
}

void draw() {
  background(0);
  noStroke();
  fill(0, 31);
  rect(0, 0, width, height);

  for (int i = 0; i < NUM; i++) {
    fill(random(255), random(255), random(255));

    particles[i].update();
    particles[i].draw();
    particles[i].bounceOffWalls();
  }
}

void mouseDragged() {
  for (int i = 0; i < NUM; i++) {
    PVector mouseLoc = new PVector(mouseX, mouseY);
    particles[i].attract(mouseLoc, 200, 5, 20);
  }
}

class ParticleVec3 {
  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector gravity;
  float mass;
  float friction;
  PVector min;
  PVector max;
  float radius;
  float G;

  ParticleVec3() {
    radius = 4.0;
    mass = 1.0;
    friction = 0.01;
    G = 1.0;
    location = new PVector(0.0, 0.0, 0.0);
    velocity = new PVector(0.0, 0.0, 0.0);
    acceleration = new PVector(0.0, 0.0, 0.0);
    gravity = new PVector(0.0, 0.0, 0.0);
    min = new PVector(0, 0, 0);
    max = new PVector(width, height, height / 2);
  }

  void update() {
    acceleration.add(gravity);
    velocity.add(acceleration);
    velocity.mult(1.0 - friction);
    location.add(velocity);
    acceleration.set(0, 0, 0);
  }

  void draw() {
    pushMatrix();
    translate(location.x, location.y, location.z);
    ellipse(0, 0, mass * radius * 2, mass * radius * 2);
    popMatrix();
  }

  void addForce(PVector force) {
    force.div(mass);
    acceleration.add(force);
  }

  void attract(PVector center, float _mass, float min, float max) {
    float distance = PVector.dist(center, location);
    distance = constrain(distance, min, max);
    float strength = G * (mass * _mass) / (distance * distance);
    PVector force = PVector.sub(center, location);
    force.normalize();
    force.mult(strength);
    addForce(force);
  }

  void bounceOffWalls() {
    if (location.x > max.x) {
      location.x = max.x;
      velocity.x *= -1;
    }
    if (location.x < min.x) {
      location.x = min.x;
      velocity.x *= -1;
    }
    if (location.y > max.y) {
      location.y = max.y;
      velocity.y *= -1;
    }
    if (location.y < min.y) {
      location.y = min.y;
      velocity.y *= -1;
    }
    if (location.z > max.z) {
      location.z = max.z;
      velocity.z *= -1;
    }
    if (location.z < min.z) {
      location.z = min.z;
      velocity.z *= -1;
    }
  }
}

# 🌐 Lencho Server – AI & Backend Services  
**Repository:** `lencho-server`  
Part of the [Lencho App](https://github.com/orange-carpet-org/lencho) – *For every Lencho out there* 🌾

Lencho Server provides the AI-powered backend services for the Lencho farming app, enabling features like crop disease detection and smart irrigation scheduling.

---

## 🧠 Features

- 🦠 Disease Detection API  
  Predict crop diseases from plant images using AI models.

- 💧 Irrigation Planner API  
  Generate optimized irrigation schedules based on weather and crop data.

- 🧩 Model Management  
  Easily update or replace machine learning models.

---

## 🚀 Getting Started

### Prerequisites
- Python 3.11.x
- pip or poetry

### Setup

```bash
1. Clone the repo  
   git clone https://github.com/orange-carpet-org/lencho-server.git  
   cd lencho-server

2. Install dependencies  
   pip install -r requirements.txt

3. Run the server  
   python app.py
```

The server should start at: http://localhost:5000

---

## 🧠 Models Used

- Disease Detection: Convolutional Neural Network built on MobileNet V2
- Irrigation Planner: Regression type model

---

## 🛠 Tech Stack
Python:
- Flask (Python)
- TensorFlow
- Keras
- Numpy
- Pandas
---

## 📦 Deployment

Can be deployed on:  
- Google Cloud
- HuggingFace
- Locally via Docker

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).

---

Empowering farmers with smart data – Lencho Server 🌱

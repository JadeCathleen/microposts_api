# Microposts API (Rails + Vue 3)

A simple CRUD application to manage microposts, built with a **Ruby on Rails API** backend and a **Vue 3 + Vite** frontend.
This project demonstrates API versioning, form handling with Vue composables, and a clean separation between backend and frontend.

---

## 🚀 Features

### **Backend (Rails API)**
- Rails 7 API-only architecture
- API versioning: `api/v1/...`
- Controllers under `app/controllers/api/v1/`
- Microposts CRUD endpoints

### **Frontend (Vue 3)**
- Vue 3 Composition API
- Vite
- Reusable composables (`useAPI`, `useForm`, etc.)
- Live validation on form inputs

---

## 📂 Project Structure

```text
microposts_api/
│
├── app/
│   ├── controllers/
│   │   └── api/
│   │       └── v1/
│   │           └── microposts_controller.rb
│   ├── models/
│   │   └── micropost.rb
│   └── views/
│       └── api/
│           └── v1/
│               └── microposts/
│                   ├── _micropost.json.jbuilder
│                   ├── index.json.jbuilder
│                   └── show.json.jbuilder
│
├── client/
│   ├── src/
│   │   ├── components/
│   │   │   ├── Posts.vue
│   │   │   ├── Post.vue
│   │   │   └── FlashMessage.vue
│   │   ├── composables/
│   │   │   ├── useApi.js
│   │   │   ├── useForm.js
│   │   │   └── usePosts.js
│   │   └── App.vue
│   └── vite.config.js
│
└── spec/
    ├── models/
    |   └── micropost_spec.rb
    └── requests/
        └── microposts_spec.rb

```

---

## 🛠️ Requirements

- Ruby 3.4.7
- Rails 8.1.1
- Node.js 20+
- Yarn or npm

---

## ⚙️ Setup & Installation

### **Clone the repository**
```bash
git clone https://github.com/JadeCathleen/microposts_api.git
cd microposts_api
```

## 📌 Backend Setup (Rails API)
### **Install dependencies**
```bash
bundle install
```
### **Setup the database**
```bash
rails db:create db:migrate db:seed
```
### **Start the Rails server**
```bash
rails s
```
The API will be available at:
```bash
http://localhost:3000/api/v1/microposts
```

---

## 🎨 Frontend Setup (Vue app)
Open a new terminal:
```bash
cd client
npm install
```
Start the local development server:
```bash
npm run dev
```
Vue frontend will run on:
```bash
http://localhost:5173
```
---

## 🔗 API Endpoints (Versioned)
| Method | Endpoint                 | Description            |
| ------ | ------------------------ | ---------------------- |
| GET    | `/api/v1/microposts`     | List all microposts    |
| POST   | `/api/v1/microposts`     | Create a new micropost |
| GET    | `/api/v1/microposts/:id` | Retrieve a micropost   |
| PATCH  | `/api/v1/microposts/:id` | Update a micropost     |
| DELETE | `/api/v1/microposts/:id` | Delete a micropost     |

---

## 🧪 Development Notes

* The API uses a custom Api::V1::BaseController inherited from ActionController::API

* CORS may require configuring rack-cors in config/application.rb

* Error handling and validation messaging is implemented in both Rails and Vue

* Vue uses a reusable API composable useAPI() for all network calls

---

🎯 Future Improvements

* Add authentication (Devise + JWT)

* Sorting & filtering

* CI/CD setup

* Deployment to Railway or Render or Fly.io

---

## 📄 License

MIT License. Feel free to use and modify this project.

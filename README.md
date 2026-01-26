# Microposts API (Rails + Vue 3)

A full-stack CRUD application to manage microposts, built with a **Ruby on Rails API** backend and a **Vue 3 + Vite** frontend.

This project demonstrates API versioning, JWT authentication, a clean separation between backend and frontend, and a real-world deployment setup.

## 🌍 Live Demo

- Frontend (Vue 3)
👉 https://micropost-api.netlify.app/

- Backend API (Rails)
👉 https://microposts-api.onrender.com
👉 Example protected endpoint: /api/v1/microposts

## Why this project?

This project was built to demonstrate:
- A Rails API-only backend with JWT authentication
- Clean separation of concerns between frontend and backend
- Vue 3 composables for reusable logic
- Real-world authentication and authorization flows
- API versioning and scalable architecture
- Deployment of a decoupled frontend and backend

## 🚀 Features

### **Backend (Rails API)**
- Rails API-only architecture
- JWT authentication with Devise and denylist
- API versioning: `api/v1/...`
- Controllers under `app/controllers/api/v1/`
- Microposts CRUD endpoints
- RSpec tests

### **Frontend (Vue 3)**
- Vue 3 Composition API
- Vite
- Vue Router
- Reusable composables (`useAPI`, `useForm`, etc.)
- JWT-based authentication
- Reactive navigation and protected routes

## 📂 Project Structure

```text
microposts_api/
│
├── app/
│   ├── controllers/
│   │   └── api/
│   │       └── v1/
│   │           ├── microposts_controller.rb
|   |           ├── registrations_controller.rb
|   |           └── sessions_controller.rb
│   ├── models/
│   │   ├── jwt_denylist.rb
│   │   ├── micropost.rb
│   │   └── user.rb
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
│   │   │   ├── Navbar.vue
│   │   │   └── FlashMessage.vue
│   │   ├── composables/
│   │   │   ├── useApi.js
│   │   │   ├── useAuth.js
│   │   │   ├── useForm.js
│   │   │   └── usePosts.js
│   │   ├── router/
│   │   │   └── index.js
│   │   ├── views/
│   │   │   ├── LoginView.vue
│   │   │   ├── PostsView.vue
│   │   │   ├── ProfileView.vue
│   │   │   └── SignUpView.vue
│   │   ├── main.js
│   │   ├── style.css
│   │   └── App.vue
│   └── vite.config.js
│
└── spec/
    ├── factories/
    |   ├── micropost.rb
    |   └── user.rb
    ├── models/
    |   └── micropost_spec.rb
    └── requests/
        └── microposts_spec.rb

```

## 🛠️ Requirements

- Ruby 3.4.7
- Rails 8.1.1
- Node.js 20+
- Yarn or npm

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
Make sure the frontend points to the API using:
```env
VITE_API_URL=http://localhost:3000
```

## 🚀 Deployment

### Backend – Render

* Deployed as a Rails API-only service
* Database migrations and seed run during the build
* JWT authentication enabled
* Hosted at:
👉 https://microposts-api.onrender.com

### Frontend – Netlify

* Built with Vite
* Deployed as a static SPA
* Environment variable:
  ```env
  VITE_API_URL=https://microposts-api.onrender.com
  ````
* Vue Router configured with Netlify redirects
* Hosted at:
👉 https://micropost-api.netlify.app/

This setup allows the frontend and backend to scale independently.

## 🔗 API Endpoints (Versioned)

| Method | Endpoint                 | Description            |
| ------ | ------------------------ | ---------------------- |
| GET    | `/api/v1/microposts`     | List all microposts    |
| POST   | `/api/v1/microposts`     | Create a new micropost |
| GET    | `/api/v1/microposts/:id` | Retrieve a micropost   |
| PATCH  | `/api/v1/microposts/:id` | Update a micropost     |
| DELETE | `/api/v1/microposts/:id` | Delete a micropost     |


## 🧪 Testing

To run them:
```sh
bundle exec rspec
```

## 🧪 Development Notes

* API inherits from a custom Api::V1::BaseController
* CORS is configured for cross-origin frontend access
* Authentication handled via JWT stored client-side
* Vue uses composables for API calls and auth state
* Navbar reacts to authentication state changes

## 🎯 Future Improvements

* Sorting & filtering
* CI/CD pipeline
* Role-based authorization
* Refresh token rotation

## 📄 License

MIT License. Feel free to use and modify this project.

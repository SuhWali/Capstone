# Intelligent Learning System

This project is an Intelligent Learning System designed to enhance K-12 mathematics education by providing personalized content recommendations and automated tagging of educational materials. The system uses advanced AI models, including Natural Language Processing (NLP) and Multimodel Generative AI, to extract key concepts and map them to educational standards like the Common Core. The application is built using a scalable architecture with Angular (frontend), Django (backend), and PostgreSQL (database), containerized using Docker for seamless development. For more details, please refer to the project report in the repository, named 'capstone_project'.

## Features
- Automated extraction and tagging of educational content.
- Personalized content recommendations based on student interactions.
- Integration with advanced AI models for content analysis.
- Secure and modular design using JWT authentication.

---

## Installation and Setup

### Prerequisites
- Install [Docker](https://docs.docker.com/get-docker/).

### Step 1: Clone the Repository
```bash
git clone https://github.com/YourUsername/YourRepository.git
cd YourRepository
```

### Step 2: Fill the `.env` File
Create a `.env` file in the root directory and add the following credentials:
```env
# Database Credentials
DB_NAME=your_database_name
DB_USER=your_database_user
DB_PASSWORD=your_database_password
DB_HOST=db
DB_PORT=5432

# OpenAI API Key
OPENAI_API_KEY=your_openai_api_key

# LangChain API Key
LANGCHAIN_API_KEY=your_langchain_api_key
```

### Step 3: Build and Start the Application
Use Docker Compose to build and start the application:
```bash
docker-compose up --build
```

This command will:
- Build the Angular frontend, Django backend, and PostgreSQL containers.
- Start the containers and link them together.

### Step 4: Initialize the Database
Run database migrations to set up the required tables:
```bash
docker-compose exec backend python manage.py migrate
```


---

## Usage
Once the application is running:
1. Access the frontend at `http://localhost:4200`.
2. Use the backend API at `http://localhost:8000/api`.

---

## Development Workflow
- **Frontend**: Modify the Angular app in the `frontend` directory. Changes are hot-reloaded if the container is running.
- **Backend**: Update the Django app in the `backend` directory. Apply changes by restarting the backend container.

---

## Troubleshooting
- If you encounter issues with container communication, ensure Docker Compose is properly configured in `docker-compose.yml`.
- Check logs for debugging:
  ```bash
  docker-compose logs
  ```

# Docker Setup and Database Initialization

## Overview

The application is containerized using Docker and Docker Compose. This setup includes:
- PostgreSQL database container
- Flask application container
- Automatic database initialization
- Volume persistence for data

## Prerequisites

- Docker (version 20.10 or higher)
- Docker Compose (version 2.0 or higher)

## Quick Start

### 1. Clone and Navigate
```bash
cd call_quality_analysis
```

### 2. Set Environment Variables
```bash
cp .env.example .env
# Edit .env file with your configuration
```

### 3. Build and Start Containers
```bash
docker-compose up --build
```

This will:
- Build the Flask application image
- Start PostgreSQL container
- Initialize the database
- Run database migrations
- Start the Flask application

### 4. Access the Application
- API: http://localhost:5000
- PostgreSQL: localhost:5432

## Docker Compose Services

### PostgreSQL Service (`db`)
- **Image**: `postgres:15-alpine`
- **Port**: `5432`
- **Database**: `call_quality_db`
- **User**: `call_quality_user`
- **Password**: `call_quality_password` (change in production!)
- **Volume**: `postgres_data` (persistent storage)
- **Initialization**: Runs `init_db.sql` on first startup

### Flask Application Service (`app`)
- **Base Image**: `python:3.11-slim`
- **Port**: `5000`
- **Depends on**: `db` service (waits for database to be healthy)
- **Volumes**: 
  - Application code (for development)
  - Logs directory

## Database Initialization

### Automatic Initialization

When the PostgreSQL container starts for the first time:
1. Creates the database (`call_quality_db`)
2. Creates the user (`call_quality_user`)
3. Runs `init_db.sql` script
4. Sets up extensions (uuid-ossp)

### Manual Initialization (if needed)

If you need to manually initialize:

```bash
# Connect to database
docker-compose exec db psql -U call_quality_user -d call_quality_db

# Or from host machine
psql -h localhost -U call_quality_user -d call_quality_db
```

### Database Migrations

Migrations are run automatically when the app container starts:
```bash
flask db upgrade
```

To run migrations manually:
```bash
docker-compose exec app flask db upgrade
```

To create a new migration:
```bash
docker-compose exec app flask db migrate -m "Migration message"
```

## Development Workflow

### Start Services
```bash
docker-compose up
```

### Start in Background
```bash
docker-compose up -d
```

### View Logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f app
docker-compose logs -f db
```

### Stop Services
```bash
docker-compose down
```

### Stop and Remove Volumes (⚠️ Deletes Data)
```bash
docker-compose down -v
```

### Rebuild After Code Changes
```bash
docker-compose up --build
```

### Execute Commands in Container
```bash
# Run Python shell
docker-compose exec app python

# Run Flask CLI commands
docker-compose exec app flask db upgrade
docker-compose exec app flask shell

# Access database
docker-compose exec db psql -U call_quality_user -d call_quality_db
```

## Production Considerations

### Security

1. **Change Default Passwords**:
   - Update `POSTGRES_PASSWORD` in `docker-compose.yml`
   - Use strong, unique passwords

2. **Environment Variables**:
   - Never commit `.env` file
   - Use secrets management in production
   - Set `JWT_SECRET_KEY` to a strong random value

3. **Network Security**:
   - Don't expose database port in production
   - Use internal Docker networks
   - Configure firewall rules

### Configuration

1. **Update `docker-compose.yml`**:
   ```yaml
   # Remove port mapping for database in production
   # ports:
   #   - "5432:5432"
   ```

2. **Use Production Database**:
   - Consider managed PostgreSQL service
   - Update `DATABASE_URL` in environment

3. **Resource Limits**:
   ```yaml
   services:
     app:
       deploy:
         resources:
           limits:
             cpus: '1'
             memory: 1G
   ```

## Troubleshooting

### Database Connection Issues

```bash
# Check if database is running
docker-compose ps

# Check database logs
docker-compose logs db

# Test database connection
docker-compose exec app python -c "from app import db; db.engine.connect()"
```

### Reset Database

```bash
# Stop containers and remove volumes
docker-compose down -v

# Start again (will reinitialize)
docker-compose up
```

### View Database Data

```bash
# Connect to database
docker-compose exec db psql -U call_quality_user -d call_quality_db

# List tables
\dt

# Query data
SELECT * FROM tenants;
```

### Application Issues

```bash
# Check application logs
docker-compose logs app

# Restart application
docker-compose restart app

# Rebuild application
docker-compose up --build app
```

## File Structure

```
call_quality_analysis/
├── docker-compose.yml      # Docker Compose configuration
├── Dockerfile              # Flask application image
├── .dockerignore          # Files to exclude from Docker build
├── init_db.sql            # Database initialization script
├── .env.example           # Example environment variables
└── .env                   # Your environment variables (not in git)
```

## Environment Variables

Key environment variables (set in `.env` or `docker-compose.yml`):

- `DATABASE_URL`: PostgreSQL connection string
- `JWT_SECRET_KEY`: Secret key for JWT tokens
- `JWT_EXPIRATION_DELTA`: Token expiration in seconds (default: 3600)
- `FLASK_ENV`: Environment (development/production)
- `LOG_LEVEL`: Logging level (DEBUG/INFO/WARNING/ERROR)

## Next Steps

1. **Initial Setup**:
   ```bash
   docker-compose up --build
   ```

2. **Create Initial Migration**:
   ```bash
   docker-compose exec app flask db migrate -m "Initial migration"
   docker-compose exec app flask db upgrade
   ```

3. **Create Initial Tenant/User** (via script or direct DB access):
   - See database initialization scripts

4. **Test API**:
   ```bash
   curl http://localhost:5000/api/v1/auth/login
   ```


# Leihs Docker Setup - Usage Guide

## 🚀 Quick Start

```powershell
docker compose up -d
```

Access Leihs at: **http://localhost**

## 🌐 Services & Access

### Via Nginx Reverse Proxy (Recommended):
- **Main URL**: http://localhost
- **Admin Panel**: http://localhost/admin
- **Borrow (User Portal)**: http://localhost/borrow
- **My Account**: http://localhost/my
- **Procurement**: http://localhost/procure
- **Inventory**: http://localhost/inventory

### Direct Service Access (for debugging):
- Admin: http://localhost:3220
- Borrow: http://localhost:3250
- My Account: http://localhost:3240
- Procurement: http://localhost:3230
- Inventory: http://localhost:3260
- Legacy API: http://localhost:3210

### Database:
- **PostgreSQL**: localhost:5415
  - User: `nuraeni05`
  - Password: `pass123456`
  - Database: `leihs`

## 📝 Commands

### Start all services:
```powershell
docker compose up -d
```

### Stop all services:
```powershell
docker compose down
```

### View logs:
```powershell
# All services
docker compose logs -f

# Specific service
docker compose logs -f admin
docker compose logs -f legacy
```

### Restart a service:
```powershell
docker compose restart admin
```

### Check service status:
```powershell
docker compose ps
```

## 🔧 Configuration

Edit `.env` file to change:
- Database credentials
- Service ports
- External hostname/URLs

## 🗄️ Database Management

### Reset database (delete all data):
```powershell
docker compose down -v
docker compose up -d
```

### Access PostgreSQL:
```powershell
docker exec -it leihs-postgres psql -U nuraeni05 -d leihs
```

## 📦 Built Components

All services are compiled and ready:
- ✅ Admin JAR
- ✅ Borrow JAR
- ✅ My JAR
- ✅ Procure JAR
- ✅ Mail JAR
- ✅ Legacy Rails app
- ⚠️ Inventory (in progress)

## 🎯 First-Time Setup

1. Services start automatically with `docker compose up -d`
2. Database migrations run automatically
3. Access any service URL above
4. **Note**: You'll need to create an admin user first (requires database seed or manual insertion)

## 🐛 Troubleshooting

### Service not responding:
```powershell
docker compose logs <service-name> --tail=50
```

### Database connection issues:
```powershell
docker compose logs postgres
docker compose logs database
```

### Rebuild after code changes:
```powershell
docker compose build
docker compose up -d
```

# RDS Deployment

## Deployment Steps:

1. **Create .env file from example:**
   ```bash
   cp .env.example .env
   ```

2. **Edit .env file with real RDS data:**
   ```bash
   nano .env
   ```
   
   Set:
   - `RDS_HOST` - your RDS endpoint
   - `RDS_USER` - database user (usually admin)
   - `RDS_PASSWORD` - database password
   - `RDS_DATABASE` - database name

3. **Start containers:**
   ```bash
   docker compose -f docker-compose-rds.yml up -d
   ```

4. **Check services:**
   - Django: http://your-server:8080
   - Drupal: http://your-server:8081

## Notes:
- .env file is not tracked by git (added to .gitignore)
- Passwords are stored only locally on the server
- RDS should be created beforehand with proper security settings

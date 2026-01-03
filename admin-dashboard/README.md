# Swasth aur Abhiman Admin Dashboard

A comprehensive React-based admin dashboard for managing the Swasth aur Abhiman platform.

## Features

- **Dashboard Overview**: Real-time statistics and analytics
- **File Upload**: Upload videos, images, and documents with progress tracking
- **Content Management**: CRUD operations for all media content
- **User Management**: Manage users, assign roles (USER, TEACHER, TRAINER, ADMIN)
- **Analytics**: View platform statistics and usage metrics
- **Storage Management**: Switch between local and cloud storage backends (S3/MinIO)
- **Settings**: Configure storage backend and view system information

## Architecture

### Components
- **Layout**: Main application wrapper with sidebar navigation
- **FileUpload**: Single file upload interface
- **ContentManagement**: Media content CRUD table
- **UserManagement**: User role and permission management
- **Settings**: Storage configuration and statistics

### Pages
- **Login**: Authentication page
- **Dashboard**: Overview with charts and statistics

### Services
- **API Client**: Axios-based HTTP client with auth interceptors
- **Stores**: Zustand state management for auth and UI state

## Installation

```bash
npm install
```

## Configuration

Create a `.env` file in the root directory:

```env
REACT_APP_API_URL=http://localhost:3000/api
```

## Running

```bash
npm start
```

The app will start at `http://localhost:3000`

### Build for Production

```bash
npm run build
```

## API Endpoints

The dashboard integrates with the backend API:

- `POST /auth/login` - User authentication
- `GET /media` - Get all media content
- `POST /media/upload` - Upload single file
- `POST /media/upload/thumbnail` - Upload thumbnail
- `POST /media/upload/bulk` - Bulk upload
- `PATCH /media/:id` - Update media
- `DELETE /media/:id` - Delete media
- `GET /users` - Get all users
- `PATCH /users/:id/role` - Update user role
- `DELETE /users/:id` - Delete user
- `GET /admin/analytics` - Get analytics
- `GET /storage/backend` - Get current storage backend
- `POST /storage/backend` - Switch storage backend

## Default Credentials

Admin credentials should be created during backend setup. See backend documentation for initial user setup.

## Storage Backends

### Local Storage
- Stores files on the local filesystem
- Suitable for development
- No external dependencies

### Cloud Storage (AWS S3 / MinIO)
- Scalable cloud storage
- Supports AWS S3 or self-hosted MinIO
- CDN integration with CloudFront
- Configure in backend `.env`:
  - `USE_CLOUD_STORAGE=true`
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`
  - `AWS_S3_BUCKET`
  - `AWS_S3_REGION`

## Technology Stack

- **React 18**: UI framework
- **React Router v6**: Client-side routing
- **Zustand**: State management
- **Axios**: HTTP client
- **Recharts**: Data visualization
- **React Hot Toast**: Notifications
- **React Icons**: Icon library
- **TypeScript**: Type safety

## Project Structure

```
src/
├── components/        # Reusable components
│   ├── Layout.tsx
│   ├── FileUpload.tsx
│   ├── ContentManagement.tsx
│   ├── UserManagement.tsx
│   └── Settings.tsx
├── pages/            # Page components
│   ├── Dashboard.tsx
│   └── Login.tsx
├── lib/              # Utilities
│   └── api.ts       # API client
├── store/            # State management
│   └── index.ts     # Zustand stores
├── App.tsx          # Main app component
└── index.tsx        # App entry point
```

## Development

### Hot Module Replacement
The dev server supports HMR for instant feedback during development.

### TypeScript
Full TypeScript support with strict mode enabled.

### Styling
CSS modules for component-scoped styling. CSS variables defined in `index.css` for theming.

## Security

- JWT-based authentication
- Token stored in localStorage
- Automatic token refresh on 401 responses
- Role-based access control (RBAC)
- Protected routes require valid token

## Troubleshooting

### "API connection refused"
Ensure the backend server is running on the configured port.

### "Invalid token"
Clear localStorage and log in again:
```javascript
localStorage.clear();
```

### "Storage backend switch failed"
Verify backend cloud storage configuration and credentials.

## Support

For issues and questions, please refer to the main project documentation.

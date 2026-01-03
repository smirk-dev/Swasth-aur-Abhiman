import React, { useEffect } from 'react';
import { Routes, Route, Navigate } from 'react-router-dom';
import { useAuthStore } from './store';
import { initializeAPI } from './lib/api';
import { Layout } from './components/Layout';
import { Dashboard } from './pages/Dashboard';
import { Login } from './pages/Login';
import { FileUpload } from './components/FileUpload';
import { ContentManagement } from './components/ContentManagement';
import { UserManagement } from './components/UserManagement';
import { Settings } from './components/Settings';
import './App.css';

const ProtectedRoute: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const { token } = useAuthStore();
  if (!token) {
    return <Navigate to="/login" replace />;
  }
  return <>{children}</>;
};

const App: React.FC = () => {
  const { token } = useAuthStore();

  useEffect(() => {
    if (token) {
      initializeAPI();
    }
  }, [token]);

  return (
    <Routes>
      <Route path="/login" element={<Login />} />
      <Route
        path="/*"
        element={
          <ProtectedRoute>
            <Layout>
              <Routes>
                <Route path="/dashboard" element={<Dashboard />} />
                <Route path="/upload" element={<FileUpload />} />
                <Route path="/content" element={<ContentManagement />} />
                <Route path="/users" element={<UserManagement />} />
                <Route path="/settings" element={<Settings />} />
                <Route path="/" element={<Navigate to="/dashboard" replace />} />
              </Routes>
            </Layout>
          </ProtectedRoute>
        }
      />
    </Routes>
  );
};

export default App;

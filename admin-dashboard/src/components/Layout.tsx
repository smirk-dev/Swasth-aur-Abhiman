import React from 'react';
import { FiMenu, FiX, FiLogOut, FiSettings } from 'react-icons/fi';
import { useUIStore, useAuthStore } from '../../store';
import './Layout.css';

interface LayoutProps {
  children: React.ReactNode;
}

export const Layout: React.FC<LayoutProps> = ({ children }) => {
  const { sidebarOpen, toggleSidebar } = useUIStore();
  const { logout, user } = useAuthStore();

  const handleLogout = () => {
    logout();
    window.location.href = '/login';
  };

  return (
    <div className="layout">
      {/* Sidebar */}
      <aside className={`sidebar ${sidebarOpen ? 'open' : 'closed'}`}>
        <div className="sidebar-header">
          <h2>Admin Panel</h2>
          <button className="close-btn" onClick={toggleSidebar}>
            <FiX />
          </button>
        </div>
        <nav className="sidebar-nav">
          <a href="/dashboard" className="nav-link">Dashboard</a>
          <a href="/content" className="nav-link">Content Management</a>
          <a href="/upload" className="nav-link">Upload Files</a>
          <a href="/users" className="nav-link">User Management</a>
          <a href="/analytics" className="nav-link">Analytics</a>
          <a href="/settings" className="nav-link">Settings</a>
        </nav>
      </aside>

      {/* Main Content */}
      <div className="main-content">
        {/* Header */}
        <header className="header">
          <button className="toggle-btn" onClick={toggleSidebar}>
            <FiMenu />
          </button>
          <div className="header-title">
            <h1>Swasth aur Abhiman - Admin Dashboard</h1>
          </div>
          <div className="header-actions">
            <a href="/settings" className="icon-btn" title="Settings">
              <FiSettings />
            </a>
            <button className="icon-btn logout-btn" onClick={handleLogout} title="Logout">
              <FiLogOut />
            </button>
            {user && <span className="user-name">{user.email}</span>}
          </div>
        </header>

        {/* Content */}
        <main className="content">
          {children}
        </main>
      </div>
    </div>
  );
};

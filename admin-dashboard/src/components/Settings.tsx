import React, { useState } from 'react';
import toast from 'react-hot-toast';
import { useUIStore } from '../store';
import { api } from '../lib/api';
import './Settings.css';

export const Settings: React.FC = () => {
  const { useCloudStorage, setUseCloudStorage } = useUIStore();
  const [storageStats, setStorageStats] = useState<any>(null);
  const [loading, setLoading] = useState(false);

  const handleStorageToggle = async () => {
    try {
      setLoading(true);
      await api.switchStorageBackend(!useCloudStorage);
      setUseCloudStorage(!useCloudStorage);
      toast.success(
        `Switched to ${!useCloudStorage ? 'Cloud' : 'Local'} storage`
      );
    } catch (error) {
      toast.error('Failed to switch storage backend');
    } finally {
      setLoading(false);
    }
  };

  const fetchStorageStats = async () => {
    try {
      const response = await api.getStorageStats();
      setStorageStats(response.data);
    } catch (error) {
      toast.error('Failed to fetch storage stats');
    }
  };

  return (
    <div className="settings">
      <h2>Settings</h2>

      <div className="settings-card">
        <h3>Storage Configuration</h3>
        <div className="setting-item">
          <div className="setting-info">
            <p className="label">Storage Backend</p>
            <p className="value">
              {useCloudStorage ? '☁️ Cloud (S3/MinIO)' : '💾 Local Storage'}
            </p>
          </div>
          <button
            className="toggle-btn"
            onClick={handleStorageToggle}
            disabled={loading}
          >
            {loading ? 'Switching...' : 'Switch'}
          </button>
        </div>

        <button
          className="stats-btn"
          onClick={fetchStorageStats}
          style={{ marginTop: '1rem' }}
        >
          Load Storage Stats
        </button>

        {storageStats && (
          <div className="stats-grid" style={{ marginTop: '1rem' }}>
            <div className="stat-item">
              <p className="stat-label">Total Files</p>
              <p className="stat-value">{storageStats.totalFiles || 0}</p>
            </div>
            <div className="stat-item">
              <p className="stat-label">Total Size</p>
              <p className="stat-value">
                {(storageStats.totalSize / (1024 * 1024)).toFixed(2)} MB
              </p>
            </div>
            <div className="stat-item">
              <p className="stat-label">Usage %</p>
              <p className="stat-value">
                {Math.round(
                  (storageStats.totalSize / (100 * 1024 * 1024)) * 100
                )}%
              </p>
            </div>
          </div>
        )}
      </div>

      <div className="settings-card">
        <h3>About</h3>
        <div className="about-content">
          <p>
            <strong>Swasth aur Abhiman Admin Dashboard</strong>
          </p>
          <p>Version: 1.0.0</p>
          <p>
            A comprehensive platform for managing health and skill training
            content.
          </p>
          <p style={{ marginTop: '1rem', fontSize: '0.875rem', color: '#6b7280' }}>
            © 2024 All rights reserved
          </p>
        </div>
      </div>
    </div>
  );
};

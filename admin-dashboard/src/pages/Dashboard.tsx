import React, { useState, useEffect } from 'react';
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from 'recharts';
import { api } from '../../lib/api';
import './Dashboard.css';

export const Dashboard: React.FC = () => {
  const [analytics, setAnalytics] = useState<any>(null);
  const [mediaStats, setMediaStats] = useState<any>(null);
  const [userStats, setUserStats] = useState<any>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchData();
  }, []);

  const fetchData = async () => {
    try {
      const [analyticsRes, mediaRes, usersRes] = await Promise.all([
        api.getAnalytics(),
        api.getMediaStats(),
        api.getUserStats(),
      ]);
      setAnalytics(analyticsRes.data);
      setMediaStats(mediaRes.data);
      setUserStats(usersRes.data);
    } catch (error) {
      console.error('Failed to fetch dashboard data');
    } finally {
      setLoading(false);
    }
  };

  if (loading) {
    return <div className="dashboard"><p>Loading dashboard...</p></div>;
  }

  const stats = [
    {
      label: 'Total Users',
      value: userStats?.total || 0,
      color: 'primary',
    },
    {
      label: 'Total Content',
      value: mediaStats?.total || 0,
      color: 'secondary',
    },
    {
      label: 'Total Views',
      value: (mediaStats?.totalViews || 0).toLocaleString(),
      color: 'success',
    },
    {
      label: 'Avg Rating',
      value: (mediaStats?.avgRating || 0).toFixed(1),
      color: 'warning',
    },
  ];

  const chartData = analytics?.dailyStats || [];

  return (
    <div className="dashboard">
      <h1>Dashboard Overview</h1>

      <div className="stats-grid">
        {stats.map((stat, idx) => (
          <div key={idx} className={`stat-card ${stat.color}`}>
            <p className="stat-label">{stat.label}</p>
            <p className="stat-number">{stat.value}</p>
          </div>
        ))}
      </div>

      <div className="chart-container">
        <h2>Views Over Time</h2>
        {chartData.length > 0 ? (
          <ResponsiveContainer width="100%" height={300}>
            <LineChart data={chartData}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="date" />
              <YAxis />
              <Tooltip />
              <Legend />
              <Line
                type="monotone"
                dataKey="views"
                stroke="var(--primary)"
                strokeWidth={2}
              />
            </LineChart>
          </ResponsiveContainer>
        ) : (
          <p className="no-data">No analytics data available</p>
        )}
      </div>

      <div className="info-grid">
        <div className="info-card">
          <h3>Content by Category</h3>
          <ul>
            {mediaStats?.byCategory?.map((cat: any, idx: number) => (
              <li key={idx}>
                <span>{cat.category}</span>
                <strong>{cat.count}</strong>
              </li>
            ))}
          </ul>
        </div>

        <div className="info-card">
          <h3>Users by Role</h3>
          <ul>
            {userStats?.byRole?.map((role: any, idx: number) => (
              <li key={idx}>
                <span>{role.role}</span>
                <strong>{role.count}</strong>
              </li>
            ))}
          </ul>
        </div>
      </div>
    </div>
  );
};

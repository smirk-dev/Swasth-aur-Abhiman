import axios, { AxiosInstance } from 'axios';
import { useAuthStore } from '../store';

const API_BASE_URL = process.env.REACT_APP_API_URL || 'http://localhost:3000/api';

let apiClient: AxiosInstance;

export const initializeAPI = () => {
  apiClient = axios.create({
    baseURL: API_BASE_URL,
    headers: {
      'Content-Type': 'application/json',
    },
  });

  // Add auth token to requests
  apiClient.interceptors.request.use((config) => {
    const token = useAuthStore.getState().token;
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  });

  // Handle unauthorized responses
  apiClient.interceptors.response.use(
    (response) => response,
    (error) => {
      if (error.response?.status === 401) {
        useAuthStore.getState().logout();
        window.location.href = '/login';
      }
      return Promise.reject(error);
    }
  );

  return apiClient;
};

export const getAPI = () => {
  if (!apiClient) {
    initializeAPI();
  }
  return apiClient;
};

export const api = {
  // Auth
  login: (credentials: any) =>
    getAPI().post('/auth/login', credentials),
  
  // File Upload
  uploadFile: (file: File, category: string) => {
    const formData = new FormData();
    formData.append('file', file);
    formData.append('category', category);
    return getAPI().post('/media/upload', formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
  },
  
  uploadThumbnail: (file: File, mediaId: string) => {
    const formData = new FormData();
    formData.append('file', file);
    formData.append('mediaId', mediaId);
    return getAPI().post('/media/upload/thumbnail', formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
  },

  bulkUpload: (files: File[], category: string) => {
    const formData = new FormData();
    files.forEach(file => formData.append('files', file));
    formData.append('category', category);
    return getAPI().post('/media/upload/bulk', formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
  },

  // Media Content
  getAllMedia: (page?: number, limit?: number) =>
    getAPI().get('/media', { params: { page, limit } }),

  getMediaById: (id: string) =>
    getAPI().get(`/media/${id}`),

  updateMedia: (id: string, data: any) =>
    getAPI().patch(`/media/${id}`, data),

  deleteMedia: (id: string) =>
    getAPI().delete(`/media/${id}`),

  // Users
  getAllUsers: (page?: number, limit?: number) =>
    getAPI().get('/users', { params: { page, limit } }),

  getUserById: (id: string) =>
    getAPI().get(`/users/${id}`),

  updateUser: (id: string, data: any) =>
    getAPI().patch(`/users/${id}`, data),

  updateUserRole: (id: string, role: string) =>
    getAPI().patch(`/users/${id}/role`, { role }),

  deleteUser: (id: string) =>
    getAPI().delete(`/users/${id}`),

  // Analytics
  getAnalytics: (startDate?: string, endDate?: string) =>
    getAPI().get('/admin/analytics', { params: { startDate, endDate } }),

  getMediaStats: () =>
    getAPI().get('/admin/media-stats'),

  getUserStats: () =>
    getAPI().get('/admin/user-stats'),

  // Storage Management
  getStorageStats: () =>
    getAPI().get('/storage/stats'),

  switchStorageBackend: (useCloud: boolean) =>
    getAPI().post('/storage/backend', { useCloud }),

  getStorageBackend: () =>
    getAPI().get('/storage/backend'),
};

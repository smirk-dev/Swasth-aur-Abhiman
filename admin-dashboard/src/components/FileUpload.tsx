import React, { useState } from 'react';
import { FiUpload, FiLoader } from 'react-icons/fi';
import toast from 'react-hot-toast';
import { api } from '../lib/api';
import './FileUpload.css';

export const FileUpload: React.FC = () => {
  const [file, setFile] = useState<File | null>(null);
  const [category, setCategory] = useState('video');
  const [uploading, setUploading] = useState(false);
  const [progress, setProgress] = useState(0);

  const categories = [
    { value: 'video', label: 'Video' },
    { value: 'thumbnail', label: 'Thumbnail' },
    { value: 'document', label: 'Document' },
    { value: 'audio', label: 'Audio' },
    { value: 'image', label: 'Image' },
  ];

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files?.[0]) {
      setFile(e.target.files[0]);
    }
  };

  const handleUpload = async () => {
    if (!file) {
      toast.error('Please select a file');
      return;
    }

    setUploading(true);
    try {
      const response = await api.uploadFile(file, category);
      toast.success('File uploaded successfully');
      setFile(null);
      setProgress(0);
    } catch (error: any) {
      toast.error(error.response?.data?.message || 'Upload failed');
    } finally {
      setUploading(false);
    }
  };

  return (
    <div className="file-upload">
      <div className="upload-card">
        <div className="upload-icon">
          <FiUpload />
        </div>
        <h2>Upload File</h2>
        <p>Upload videos, images, or documents</p>

        <div className="form-group">
          <label>Category</label>
          <select value={category} onChange={(e) => setCategory(e.target.value)}>
            {categories.map((cat) => (
              <option key={cat.value} value={cat.value}>
                {cat.label}
              </option>
            ))}
          </select>
        </div>

        <div className="form-group">
          <label>Select File</label>
          <input
            type="file"
            onChange={handleFileChange}
            disabled={uploading}
            accept="video/*,image/*,.pdf,.doc,.docx"
          />
          {file && <span className="file-name">{file.name}</span>}
        </div>

        {progress > 0 && (
          <div className="progress-bar">
            <div className="progress" style={{ width: `${progress}%` }}></div>
            <span>{progress}%</span>
          </div>
        )}

        <button
          className="upload-btn"
          onClick={handleUpload}
          disabled={!file || uploading}
        >
          {uploading ? (
            <>
              <FiLoader className="spinner" /> Uploading...
            </>
          ) : (
            'Upload'
          )}
        </button>
      </div>
    </div>
  );
};

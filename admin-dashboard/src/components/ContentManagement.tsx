import React, { useState, useEffect } from 'react';
import { FiEdit2, FiTrash2, FiEye } from 'react-icons/fi';
import toast from 'react-hot-toast';
import { api } from '../lib/api';
import './ContentManagement.css';

interface MediaItem {
  id: string;
  title: string;
  description: string;
  category: string;
  views: number;
  rating: number;
  createdAt: string;
  url: string;
}

export const ContentManagement: React.FC = () => {
  const [media, setMedia] = useState<MediaItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [page, setPage] = useState(1);
  const [total, setTotal] = useState(0);

  useEffect(() => {
    fetchMedia();
  }, [page]);

  const fetchMedia = async () => {
    try {
      setLoading(true);
      const response = await api.getAllMedia(page, 20);
      setMedia(response.data.data || []);
      setTotal(response.data.total || 0);
    } catch (error) {
      toast.error('Failed to fetch media');
    } finally {
      setLoading(false);
    }
  };

  const handleDelete = async (id: string) => {
    if (!window.confirm('Are you sure?')) return;
    try {
      await api.deleteMedia(id);
      toast.success('Deleted successfully');
      fetchMedia();
    } catch (error) {
      toast.error('Delete failed');
    }
  };

  if (loading) {
    return <div className="content-management"><p>Loading...</p></div>;
  }

  const totalPages = Math.ceil(total / 20);

  return (
    <div className="content-management">
      <div className="header">
        <h2>Content Management</h2>
        <p>{total} items total</p>
      </div>

      <div className="table-container">
        <table className="content-table">
          <thead>
            <tr>
              <th>Title</th>
              <th>Category</th>
              <th>Views</th>
              <th>Rating</th>
              <th>Created</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            {media.map((item) => (
              <tr key={item.id}>
                <td className="title">{item.title}</td>
                <td><span className="badge">{item.category}</span></td>
                <td>{item.views}</td>
                <td>
                  <span className="rating">
                    {'⭐'.repeat(Math.round(item.rating))}
                  </span>
                </td>
                <td>{new Date(item.createdAt).toLocaleDateString()}</td>
                <td className="actions">
                  <button className="btn-icon" title="View">
                    <FiEye />
                  </button>
                  <button className="btn-icon" title="Edit">
                    <FiEdit2 />
                  </button>
                  <button
                    className="btn-icon danger"
                    onClick={() => handleDelete(item.id)}
                    title="Delete"
                  >
                    <FiTrash2 />
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {totalPages > 1 && (
        <div className="pagination">
          <button
            onClick={() => setPage(p => Math.max(1, p - 1))}
            disabled={page === 1}
          >
            Previous
          </button>
          <span>Page {page} of {totalPages}</span>
          <button
            onClick={() => setPage(p => Math.min(totalPages, p + 1))}
            disabled={page === totalPages}
          >
            Next
          </button>
        </div>
      )}
    </div>
  );
};

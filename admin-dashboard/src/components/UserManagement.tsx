import React, { useState, useEffect } from 'react';
import toast from 'react-hot-toast';
import { api } from '../../lib/api';
import './UserManagement.css';

interface User {
  id: string;
  email: string;
  name: string;
  role: string;
  createdAt: string;
}

export const UserManagement: React.FC = () => {
  const [users, setUsers] = useState<User[]>([]);
  const [loading, setLoading] = useState(true);
  const [page, setPage] = useState(1);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [newRole, setNewRole] = useState('');

  const roles = ['USER', 'TEACHER', 'TRAINER', 'ADMIN'];

  useEffect(() => {
    fetchUsers();
  }, [page]);

  const fetchUsers = async () => {
    try {
      setLoading(true);
      const response = await api.getAllUsers(page, 20);
      setUsers(response.data.data || []);
    } catch (error) {
      toast.error('Failed to fetch users');
    } finally {
      setLoading(false);
    }
  };

  const handleRoleChange = async (id: string, role: string) => {
    try {
      await api.updateUserRole(id, role);
      toast.success('Role updated');
      setEditingId(null);
      fetchUsers();
    } catch (error) {
      toast.error('Failed to update role');
    }
  };

  const handleDelete = async (id: string) => {
    if (!confirm('Are you sure?')) return;
    try {
      await api.deleteUser(id);
      toast.success('User deleted');
      fetchUsers();
    } catch (error) {
      toast.error('Delete failed');
    }
  };

  if (loading) {
    return <div className="user-management"><p>Loading...</p></div>;
  }

  return (
    <div className="user-management">
      <div className="header">
        <h2>User Management</h2>
        <p>{users.length} users</p>
      </div>

      <div className="table-container">
        <table className="user-table">
          <thead>
            <tr>
              <th>Email</th>
              <th>Name</th>
              <th>Role</th>
              <th>Joined</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            {users.map((user) => (
              <tr key={user.id}>
                <td>{user.email}</td>
                <td>{user.name}</td>
                <td>
                  {editingId === user.id ? (
                    <select
                      value={newRole || user.role}
                      onChange={(e) => setNewRole(e.target.value)}
                      className="role-select"
                    >
                      {roles.map((r) => (
                        <option key={r} value={r}>
                          {r}
                        </option>
                      ))}
                    </select>
                  ) : (
                    <span className={`role-badge ${user.role.toLowerCase()}`}>
                      {user.role}
                    </span>
                  )}
                </td>
                <td>{new Date(user.createdAt).toLocaleDateString()}</td>
                <td className="actions">
                  {editingId === user.id ? (
                    <>
                      <button
                        className="btn-small success"
                        onClick={() =>
                          handleRoleChange(user.id, newRole || user.role)
                        }
                      >
                        Save
                      </button>
                      <button
                        className="btn-small"
                        onClick={() => setEditingId(null)}
                      >
                        Cancel
                      </button>
                    </>
                  ) : (
                    <>
                      <button
                        className="btn-small"
                        onClick={() => {
                          setEditingId(user.id);
                          setNewRole(user.role);
                        }}
                      >
                        Edit
                      </button>
                      <button
                        className="btn-small danger"
                        onClick={() => handleDelete(user.id)}
                      >
                        Delete
                      </button>
                    </>
                  )}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      <div className="pagination">
        <button
          onClick={() => setPage((p) => Math.max(1, p - 1))}
          disabled={page === 1}
        >
          Previous
        </button>
        <span>Page {page}</span>
        <button onClick={() => setPage((p) => p + 1)}>Next</button>
      </div>
    </div>
  );
};

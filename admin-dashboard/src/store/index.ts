import create from 'zustand';

interface AuthStore {
  token: string | null;
  user: any | null;
  setToken: (token: string) => void;
  setUser: (user: any) => void;
  logout: () => void;
}

export const useAuthStore = create<AuthStore>((set) => ({
  token: localStorage.getItem('adminToken') || null,
  user: localStorage.getItem('adminUser') ? JSON.parse(localStorage.getItem('adminUser')!) : null,
  setToken: (token) => {
    localStorage.setItem('adminToken', token);
    set({ token });
  },
  setUser: (user) => {
    localStorage.setItem('adminUser', JSON.stringify(user));
    set({ user });
  },
  logout: () => {
    localStorage.removeItem('adminToken');
    localStorage.removeItem('adminUser');
    set({ token: null, user: null });
  },
}));

interface UIStore {
  sidebarOpen: boolean;
  toggleSidebar: () => void;
  useCloudStorage: boolean;
  setUseCloudStorage: (use: boolean) => void;
}

export const useUIStore = create<UIStore>((set) => ({
  sidebarOpen: true,
  toggleSidebar: () => set((state) => ({ sidebarOpen: !state.sidebarOpen })),
  useCloudStorage: localStorage.getItem('useCloudStorage') === 'true',
  setUseCloudStorage: (use) => {
    localStorage.setItem('useCloudStorage', use.toString());
    set({ useCloudStorage: use });
  },
}));

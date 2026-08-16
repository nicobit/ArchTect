const STORAGE_KEY = 'archtect-sidebar-collapsed';

export function isSidebarCollapsed(): boolean {
	return document.documentElement.classList.contains('sidebar-is-collapsed');
}

export function setSidebarCollapsed(collapsed: boolean) {
	document.documentElement.classList.toggle('sidebar-is-collapsed', collapsed);
	localStorage.setItem(STORAGE_KEY, String(collapsed));
	document.dispatchEvent(new CustomEvent('sidebar-collapse-change', { detail: { collapsed } }));
}

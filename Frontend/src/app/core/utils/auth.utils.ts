// src/app/core/utils/auth.utils.ts

import { AuthState } from '../models/user.model';

export function storeAuthState(state: Partial<AuthState>) {
    if (state.token) {
        localStorage.setItem('access_token', state.token.access);
        localStorage.setItem('refresh_token', state.token.refresh);
    }
    if (state.roles) {
        localStorage.setItem('user_roles', JSON.stringify(state.roles));
    }
}

export function getStoredAuthState(): Partial<AuthState> {
    const access = localStorage.getItem('access_token');
    const refresh = localStorage.getItem('refresh_token');
    const rolesString = localStorage.getItem('user_roles');
    // console.log(access,rolesString,"skdhjfa")
    return {
        token: access && refresh ? { access, refresh } : null,
        roles: rolesString ? JSON.parse(rolesString) : [] // Always return an array
    };
}
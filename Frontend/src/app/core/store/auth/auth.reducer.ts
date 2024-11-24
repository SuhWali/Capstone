import { createReducer, on } from '@ngrx/store';
import { AuthState, TokenResponse } from '../../models/user.model';
import * as AuthActions from './auth.actions';

export const initialState: AuthState = {
    token: null,
    roles: [],
    loading: false,
    error: null
};



export const authReducer = createReducer(
    initialState,
    on(AuthActions.initializeAuth, (state) => ({
        ...state,
        loading: true,
      })),
    on(AuthActions.initializeAuthSuccess, (state, { token, roles }) => ({
        ...state,
        token,
        roles,
        loading: false,
        error: null,
      })),
      
    on(AuthActions.login, (state) => ({
        ...state,
        loading: true,
        error: null
    })),
    on(AuthActions.loginSuccess, (state, { token }) => ({
        ...state,
        token,
        loading: false,
        error: null
    })),
    on(AuthActions.loginFailure, (state, { error }) => ({
        ...state,
        token: null,
        loading: false,
        error
    })),
    on(AuthActions.logoutSuccess, () => initialState),

    on(AuthActions.getRoles, (state) => ({
        ...state,
        loading: true
    })),
    on(AuthActions.getRolesSuccess, (state, { roles }) => ({
        ...state,
        roles,
        loading: false
    })),
    on(AuthActions.getRolesFailure, (state, { error }) => ({
        ...state,
        loading: false,
        error
    }))
);
import { createAction, props } from '@ngrx/store';
import { TokenResponse } from '../../models/user.model';



export const initializeAuth = createAction('[Auth] Initialize');

export const initializeAuthSuccess = createAction(
    '[Auth] Initialize Success',
    props<{ token: TokenResponse | null; roles: string[] }>()
);



export const login = createAction(
    '[Auth] Login',
    props<{ username: string; password: string }>()
);

export const loginSuccess = createAction(
    '[Auth] Login Success',
    props<{ token: TokenResponse }>()
);

export const loginFailure = createAction(
    '[Auth] Login Failure',
    props<{ error: string }>()
);

export const getRoles = createAction('[Auth] Get Roles');

export const getRolesSuccess = createAction(
    '[Auth] Get Roles Success',
    props<{ roles: string[] }>()
);

export const getRolesFailure = createAction(
    '[Auth] Get Roles Failure',
    props<{ error: string }>()
);

export const logout = createAction('[Auth] Logout');
export const logoutSuccess = createAction('[Auth] Logout Success');

export const refreshToken = createAction('[Auth] Refresh Token');
export const refreshTokenSuccess = createAction(
    '[Auth] Refresh Token Success',
    props<{ token: string }>()
);


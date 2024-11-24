// store/auth.selectors.ts
import { createSelector } from '@ngrx/store';
import { AuthState } from '../../models/user.model';

export const selectAuth = (state: { auth: AuthState }) => state.auth;


export const selectIsInitialized = createSelector(
  selectAuth,
  (auth) => auth.loading
);

export const selectIsAuthenticated = createSelector(
  selectAuth,
  (auth) => !!auth.token

);

export const selectUserRoles = createSelector(
  selectAuth,
  (auth) => auth.roles
);
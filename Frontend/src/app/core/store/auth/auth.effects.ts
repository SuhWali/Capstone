import { Injectable } from '@angular/core';
import { Actions, createEffect, ofType } from '@ngrx/effects';
import { of } from 'rxjs';
import { map, mergeMap, catchError, tap, switchMap } from 'rxjs/operators';
import { AuthService } from '../../services/authentication.service';
import { Router } from '@angular/router';
import * as AuthActions from './auth.actions';
import { storeAuthState, getStoredAuthState } from '../../utils/auth.utils'

@Injectable()
export class AuthEffects {
    constructor(
        private actions$: Actions,
        private authService: AuthService,
        private router: Router
    ) {
    }

    // initializeAuth$ = createEffect(() =>
    //     this.actions$.pipe(
    //         ofType(AuthActions.initializeAuth),
    //         map(() => {
    //             const storedState = getStoredAuthState();
    //             if (storedState.token && storedState.roles) {
    //                 return AuthActions.initializeAuthSuccess({
    //                     token: storedState.token,
    //                     roles: storedState.roles
    //                 });
    //             }
    //             return AuthActions.loginFailure({ error: 'No stored auth state found' });
    //         })
    //     )
    // );

    initializeAuth$ = createEffect(() =>
        this.actions$.pipe(
            ofType(AuthActions.initializeAuth),
            switchMap(() => {
                const storedState = getStoredAuthState();

                if (storedState.token && storedState.roles) {
                    // Validate authentication by calling the backend endpoint
                    return this.authService.getUserRoles().pipe(
                        map(response => {

                            // Use response.roles instead of storedState.roles
                            return AuthActions.initializeAuthSuccess({
                                token: storedState.token ?? null,
                                roles: response.roles ?? null
                            });
                        }),
                        catchError((error) => {
                            return of(AuthActions.logout());
                        })
                    );
                }
                // If no stored state is found, dispatch login failure
                return of(AuthActions.loginFailure({ error: 'No stored auth state found' }));
            })
        )
    );

    login$ = createEffect(() =>
        this.actions$.pipe(
            ofType(AuthActions.login),
            mergeMap(({ username, password }) =>
                this.authService.login(username, password).pipe(
                    map(token => AuthActions.loginSuccess({ token })),
                    catchError(error => of(AuthActions.loginFailure({ error: error.message })))
                )
            )
        )
    );

    // );
    loginSuccess$ = createEffect(() =>
        this.actions$.pipe(
            ofType(AuthActions.loginSuccess),
            tap(({ token }) => {
                storeAuthState({ token });
            }),
            map(() => AuthActions.getRoles())
        )
    );

    getRoles$ = createEffect(() =>
        this.actions$.pipe(
            ofType(AuthActions.getRoles),
            switchMap(() =>
                this.authService.getUserRoles().pipe(
                    map(response => AuthActions.getRolesSuccess({ roles: response.roles })),

                    catchError(error => of(AuthActions.getRolesFailure({ error: error.message })))
                )
            )
        )
    );
    getRolesSuccess$ = createEffect(() =>
        this.actions$.pipe(
            ofType(AuthActions.getRolesSuccess),
            tap(({ roles }) => {
                storeAuthState({ roles });
                // Redirect based on role
                const defaultRole = roles[0];
                this.router.navigate([`/${defaultRole.toLowerCase()}/`]);
            })
        ),
        { dispatch: false }
    );

    logout$ = createEffect(() =>
        this.actions$.pipe(
            ofType(AuthActions.logout),
            tap(() => {
                // Clear tokens
                localStorage.removeItem('access_token');
                localStorage.removeItem('refresh_token');
                localStorage.removeItem('user_roles');
                
                // Redirect to login
                window.location.reload();
            }),
            mergeMap(() =>
                this.authService.logout().pipe(
                    map(() => {
                        return AuthActions.logoutSuccess();
                    }),
                    catchError(() => {
                        return of(AuthActions.logoutSuccess()); // Fallback to success
                    })
                )
            )
        )
    );
}
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

    initializeAuth$ = createEffect(() =>
        this.actions$.pipe(
            ofType(AuthActions.initializeAuth),
            map(() => {
                const storedState = getStoredAuthState();
                if (storedState.token && storedState.roles ) {
                    return AuthActions.initializeAuthSuccess({
                        token: storedState.token,
                        roles: storedState.roles
                    });
                }
                return AuthActions.loginFailure({ error: 'No stored auth state found' });
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
    
      getRolesSuccess$ = createEffect(() =>
        this.actions$.pipe(
          ofType(AuthActions.getRolesSuccess),
          tap(({ roles }) => {
            storeAuthState({ roles });
            // Redirect based on role
            const defaultRole = roles[0];
            this.router.navigate([`/${defaultRole.toLowerCase()}`]);
          })
        ),
        { dispatch: false }
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

    // getRolesSuccess$ = createEffect(
    //     () =>
    //         this.actions$.pipe(
    //             ofType(AuthActions.getRolesSuccess),
    //             tap(({ roles }) => {
    //                 // Navigate based on the first role (assuming one role per user)
    //                 const role = roles[0];
    //                 console.log(role, "suhayb's role ")
    //                 if (role === 'student') {
    //                     this.router.navigate(['/student/dashboard']);
    //                 } else if (role === 'instructor') {
    //                     this.router.navigate(['/instructor/dashboard']);
    //                 }
    //             })
    //         ),
    //     { dispatch: false }
    // );


    logout$ = createEffect(() =>
        this.actions$.pipe(
            ofType(AuthActions.logout),
            mergeMap(() =>
                this.authService.logout().pipe(
                    map(() => AuthActions.logoutSuccess()),
                    tap(() => {
                        localStorage.removeItem('token');
                        this.router.navigate(['/login']);
                    })
                )
            )
        )
    );

}

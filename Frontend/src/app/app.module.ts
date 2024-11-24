import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { ReactiveFormsModule } from '@angular/forms';
import { provideHttpClient, withInterceptors } from '@angular/common/http';



import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { CoreModule } from './core/core.module'
import { SharedModule } from './shared/shared.module'
// import { FeaturesModule } from './features/features.module'


import { StoreModule } from '@ngrx/store';
import { authReducer } from './core/store/auth/auth.reducer'
import { EffectsModule } from '@ngrx/effects';
import { AuthEffects } from './core/store/auth/auth.effects'
import { StoreDevtoolsModule } from '@ngrx/store-devtools';

import { authInterceptor } from './core/interceptors/auth.interceptor'

@NgModule({
  declarations: [
    AppComponent
    ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    ReactiveFormsModule,
    SharedModule,
    CoreModule,
    // FeaturesModule,

    StoreModule.forRoot( {
      auth: authReducer
    }),
    EffectsModule.forRoot([AuthEffects]),
    StoreDevtoolsModule.instrument({ maxAge: 25 }),
  ],

  providers: [provideHttpClient(
    withInterceptors([authInterceptor])
  )
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }

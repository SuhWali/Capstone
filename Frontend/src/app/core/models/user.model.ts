export interface TokenResponse {
    access: string;
    refresh: string;
}

export interface UserRoles {
    roles: string[];
  }



// export interface User {
//     id: string;
//     email: string;
//     role: 'student' | 'instructor';
//     username: string;
//     first_name: string;
//     last_name: string;
//     access: string;
//     refresh: string;
//     token : TokenResponse;
// }


export interface AuthState {
    token: TokenResponse | null;
    roles: string[] | null;
    loading: boolean;
    error: string | null;
}
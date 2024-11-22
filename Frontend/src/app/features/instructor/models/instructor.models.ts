export interface Grade {
    gradeid: number;
    gradename: string;

}


export interface Domain {
    domainid: number;
    gradeid: number;
    domain_abb: string;
    domainname: string;
}

export interface Document {
    id?: number;
    title: string;
    file: File | string;
    domain: number;
    domain_name?: string;
    uploaded_by?: number;
    uploaded_by_name?: string;
    uploaded_at?: string;
    description?: string;
}
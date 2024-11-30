export interface Grade {
    gradeid: number;
    gradename: string;

}

export interface Assessment {
    id: number;
    title: string;
    course: number;
    is_generated: boolean;
    created_at: string;
    updated_at: string;
    exercise_count: number;
}

export interface AssessmentCreateRequest {
    title: string;
    course: number;
    domain_id?: number;
    cluster_id?: number;
    standard_id?: number;
    num_exercises?: number;
}


export interface Course {
    id: number;
    name: string;
    description: string;
    grade: number;
    instructor: string;
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


export interface Cluster {

    clusterid: string;
    clustername: string;
    domain: number;
}

export interface Standard {
    id: number;
    standardid: string;
    standarddescription: string;
    cluster: number;
}
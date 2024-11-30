export interface Course {
    id: number;
    name: string;
    description: string;
    instructor_name: string;
    grade_name: string;
    created_at: string;
}

export interface CourseEnrollment {
    id: number;
    course: Course;
    enrolled_at: string;
    is_active: boolean;
}


export interface Domain {
    domainid: number;
    domain_abb: string;
    domainname: string;
}


export interface DocumentModel {
    id: number;
    instructor: number;
    domain: number;
    title: string;
    description: string | null;
    upload_date: string;
    file: string;
}


export interface Assessment {
    id: number;
    title: string;
    course: number;
    created_by: number;
    is_generated: boolean;
    created_at: string;
    updated_at: string;
}

export interface AssessmentExercise {
    id: number;
    assessment: number;
    exercise: Exercise;
    order: number;
}

export interface Exercise {
    exercise_id: number;
    content: string;  // LaTeX content
    solution?: string; // LaTeX solution if available
}


export interface Standard {
    id: number;
    name: string;
    description: string;
}

export interface Recommendation {
    id: number;
    title: string;
    content: string;
    confidence_score: number;
    type: 'exercise' | 'example' | 'document';
}



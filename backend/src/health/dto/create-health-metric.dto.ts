export class CreateHealthMetricDto {
  metricType: string; // 'BP_SYSTOLIC', 'BP_DIASTOLIC', 'BLOOD_SUGAR', 'BMI', 'WEIGHT', etc.
  value: number;
  unit?: string;
  notes?: string;
  recordedAt?: Date;
}

export class CreateHealthMetricSessionDto {
  date: string; // YYYY-MM-DD format
  bpSystolic?: number;
  bpDiastolic?: number;
  bloodSugar?: number;
  bmi?: number;
  weight?: number;
  height?: number;
  temperature?: number;
  pulse?: number;
  notes?: string;
}

export class GetHealthMetricsFilterDto {
  metricType?: string;
  startDate?: Date;
  endDate?: Date;
  limit?: number;
  offset?: number;
}

export class HealthMetricsResponseDto {
  id: string;
  metricType: string;
  value: number;
  unit: string;
  notes?: string;
  condition?: string;
  recordedAt: Date;
  createdAt: Date;
}

export class HealthMetricsSummaryDto {
  latestMetrics: {
    [key: string]: {
      value: number;
      unit: string;
      recordedAt: Date;
      condition?: string;
    };
  };
  trends: {
    [key: string]: {
      current: number;
      previous: number;
      change: number;
      changePercent: number;
    };
  };
  averages: {
    [key: string]: number;
  };
}

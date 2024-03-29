import pandas as pd    
import holidays  

def get_time_of_day(hour):  
    if 5 <= hour <= 11:  
        return 'Morning'  
    elif 12 <= hour <= 17:  
        return 'Afternoon'  
    elif 18 <= hour <= 20:  
        return 'Evening'  
    else:  
        return 'Night'

def get_season(month):  
    if month in [3, 4, 5]:  
        return 'Spring'  
    elif month in [6, 7, 8]:  
        return 'Summer'  
    elif month in [9, 10, 11]:  
        return 'Autumn'  
    else:  
        return 'Winter' 

# Generate a date range with hourly frequency    
date_range = pd.date_range(start='2021-01-01', end='2022-12-31 23:00:00', freq='h')    
  
# Create a DataFrame    
df = pd.DataFrame(date_range, columns=['date_key'])    

# Create a list of US holidays  
us_holidays = holidays.US()  

# Add the other columns    
df['hour'] = df['date_key'].dt.hour    
df['day'] = df['date_key'].dt.day    
df['day_of_week'] = df['date_key'].dt.weekday    
df['week'] = df['date_key'].dt.isocalendar().week    
df['month'] = df['date_key'].dt.month    
df['quarter'] = df['date_key'].dt.quarter    
df['year'] = df['date_key'].dt.year    
df['season'] = df['month'].apply(get_season)  
df['time_of_day'] = df['hour'].apply(get_time_of_day)    
df['is_weekend_or_holiday'] = df['date_key'].dt.date.apply(lambda x: x in us_holidays)
  
# Rearrange the columns    
df = df[['date_key', 'year', 'month', 'day', 'hour', 'time_of_day', 'quarter', 'week', 'day_of_week', 'season', 'is_weekend_or_holiday']]    
  
# Write to a CSV file    
df.to_csv('dim_date.csv', index=False)  

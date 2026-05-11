import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder, StandardScaler
from sklearn.metrics import classification_report, accuracy_score


import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense
import matplotlib.pyplot as plt

# Cargar el archivo CSV
file_path = '/Users/ariadnamanzanosperez/Downloads/Proyecto_2/Dengue/dengue_all_data_date_name.csv'
df = pd.read_csv(file_path)

# Check the column names and their types
print("Column Names and Types:")
print(df.columns)
print(df.dtypes)

# Assuming positive cases are indicated by 'RESULTADO_PCR' being 1 or 2
df_positive = df[df['RESULTADO_PCR'].isin([1, 2])]

# Encode categorical variables
label_encoder = LabelEncoder()
df_positive['ENTIDAD_ASIG'] = label_encoder.fit_transform(df_positive['ENTIDAD_ASIG'])

# Select relevant features and target variable
features = ['ENTIDAD_ASIG', 'MES', 'YEAR', 'DIABETES', 'HEMORRAGICOS']  # Add other relevant features
target = 'RESULTADO_PCR'

X = df_positive[features]
y = df_positive[target]

# Split the data into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Standardize the features
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

# Define the neural network model
model = Sequential([
    Dense(32, activation='relu', input_shape=(X_train_scaled.shape[1],)),
    Dense(16, activation='relu'),
    Dense(1, activation='sigmoid')
])

# Compile the model
model.compile(optimizer='adam', loss='binary_crossentropy', metrics=['accuracy'])

# Train the model
model.fit(X_train_scaled, y_train, epochs=50, batch_size=32, validation_split=0.2)

# Evaluate the model
loss, accuracy = model.evaluate(X_test_scaled, y_test)
print(f"Accuracy: {accuracy}")

# Make predictions on the test set
y_pred_prob = model.predict(X_test_scaled)
y_pred = (y_pred_prob > 0.5).astype("int32")

# Evaluate the model
print(classification_report(y_test, y_pred))

# Make predictions on the entire dataset
df_positive_scaled = scaler.transform(X)
df_positive['PREDICTION'] = (model.predict(df_positive_scaled) > 0.5).astype("int32")

# Decode the state labels
df_positive['ENTIDAD_ASIG'] = label_encoder.inverse_transform(df_positive['ENTIDAD_ASIG'])

# Group by state, month, and year to get actual and predicted counts
grouped_data = df_positive.groupby(['ENTIDAD_ASIG', 'YEAR', 'MES']).agg({'RESULTADO_PCR': 'sum', 'PREDICTION': 'sum'}).reset_index()

# Verify the processed data
print("Processed Data for Plotting:")
print(grouped_data.head())

# Plot actual vs predicted cases by month for each state with different colors for each year
states = grouped_data['ENTIDAD_ASIG'].unique()
for state in states:
    state_data = grouped_data[grouped_data['ENTIDAD_ASIG'] == state]
    years = state_data['YEAR'].unique()
    colors = plt.cm.get_cmap('tab10', len(years))
    
    plt.figure(figsize=(14, 10))
    
    for i, year in enumerate(years):
        yearly_data = state_data[state_data['YEAR'] == year]
        plt.plot(yearly_data['MES'], yearly_data['RESULTADO_PCR'], label=f'Actual {year}', marker='o', color=colors(i))
        plt.plot(yearly_data['MES'], yearly_data['PREDICTION'], label=f'Predicted {year}', marker='x', linestyle='--', color=colors(i))
    
    plt.title(f'Casos de Dengue en {state} (Actual vs Previsto) por Mes para Múltiples Años')
    plt.xlabel('Mes')
    plt.ylabel('Número de Casos')
    plt.legend(loc='upper right')
    
    # Save the plot with the state name in the filename
    plt.savefig(f'{state.lower()}_neu.png')

    plt.show()

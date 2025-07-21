from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field, validator
import joblib
import numpy as np
import logging

# Setup logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = FastAPI(
    title="African Recession Prediction API",
    description="API for predicting economic recession likelihood in African countries",
    version="1.0.0",
    docs_url= "/swagger",
)

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Define the expected feature names based on your model training
feature_names = [
    "pop", "emp", "emp_to_pop_ratio", "hc", "ccon", "cda", "cn", "ck",
    "rconna", "rdana", "rnna", "rkna", "rtfpna", "rwtfpna", "labsh", "irr",
    "delta", "xr", "pl_con", "pl_da", "pl_gdpo", "csh_c", "csh_i", "csh_g",
    "csh_x", "csh_m", "csh_r", "pl_c", "pl_i", "pl_g", "pl_x", "pl_m", "pl_n",
    "total", "excl_energy", "energy", "metals_minerals", "forestry",
    "agriculture", "fish", "total_change", "excl_energy_change",
    "energy_change", "metals_minerals_change", "forestry_change",
    "agriculture_change", "fish_change"
]

# Load model and scaler
try:
    model = joblib.load('../summative/linear_regression/best_model.pkl')
    scaler = joblib.load('../summative/linear_regression/scaler.pkl')
    logger.info("Model and preprocessing objects loaded successfully")
except Exception as e:
    logger.error(f"Error loading model or scaler: {e}")
    model = None
    scaler = None

# Input model
class RecessionPredictionInput(BaseModel):
    """Input model for all economic features"""
    pop: float = 0
    emp: float = 0
    emp_to_pop_ratio: float = 0.0
    hc: float = 0
    ccon: float = 0
    cda: float = 0
    cn: float = 0
    ck: float = 0
    rconna: float = 0
    rdana: float = 0
    rnna: float = 0
    rkna: float = 0
    rtfpna: float = 0
    rwtfpna: float = 0
    labsh: float = 0
    irr: float = 0
    delta: float = 0
    xr: float = 0
    pl_con: float = 0
    pl_da: float = 0
    pl_gdpo: float = 0
    csh_c: float = 0
    csh_i: float = 0
    csh_g: float = 0
    csh_x: float = 0
    csh_m: float = 0
    csh_r: float = 0
    pl_c: float = 0
    pl_i: float = 0
    pl_g: float = 0
    pl_x: float = 0
    pl_m: float = 0
    pl_n: float = 0
    total: float = 0
    excl_energy: float = 0
    energy: float = 0
    metals_minerals: float = 0
    forestry: float = 0
    agriculture: float = 0
    fish: float = 0
    total_change: float = 0
    excl_energy_change: float = 0
    energy_change: float = 0
    metals_minerals_change: float = 0
    forestry_change: float = 0
    agriculture_change: float = 0
    fish_change: float = 0

    @validator("*", pre=True)
    def ensure_float(cls, v):
        if v is None:
            return 0.0
        if isinstance(v, str):
            try:
                return float(v)
            except ValueError:
                raise ValueError("Must be numeric")
        return v

# Output model
class RecessionPredictionOutput(BaseModel):
    prediction: float
    recession_likelihood: str
    confidence: float
    interpretation: str

# Health check
@app.get("/")
async def root():
    return {
        "message": "African Recession Prediction API",
        "status": "healthy",
        "model_loaded": model is not None,
        "version": "1.0.0",
        
    }

@app.get("/health")
async def health_check():
    return {
        "status": "healthy",
        "model_status": "loaded" if model else "not_loaded",
        "features_count": len(feature_names),
        "features": feature_names[:5]
    }

# Main prediction endpoint
@app.post("/predict", response_model=RecessionPredictionOutput)
async def predict_recession(input_data: RecessionPredictionInput):
    if model is None or scaler is None:
        raise HTTPException(status_code=500, detail="Model or scaler not loaded.")

    try:
        # Convert input to list in same order as feature_names
        input_dict = input_data.dict()
        feature_vector = [input_dict.get(name, 0.0) for name in feature_names]

        # Preprocess
        X = np.array(feature_vector).reshape(1, -1)
        X_scaled = scaler.transform(X)

        # Predict
        prediction = model.predict(X_scaled)[0]

        # Interpret
        if prediction < -1:
            likelihood = "High"
            interpretation = "Strong indicators suggest high recession risk."
        elif prediction < 0:
            likelihood = "Moderate"
            interpretation = "Some indicators suggest moderate recession risk."
        elif prediction < 1:
            likelihood = "Low"
            interpretation = "Economic indicators show low recession risk."
        else:
            likelihood = "Very Low"
            interpretation = "Strong economic performance, very low recession risk."

        confidence = min(abs(prediction) * 0.3, 1.0)

        return RecessionPredictionOutput(
            prediction=float(prediction),
            recession_likelihood=likelihood,
            confidence=round(confidence, 2),
            interpretation=interpretation
        )

    except Exception as e:
        logger.error(f"Prediction error: {e}")
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/features")
async def get_features():
    return {
        "features": feature_names,
        "required_inputs": feature_names
    }

# Run with uvicorn if needed
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)

# AI Model Setups

## Cursor AI (incl. pricing)

* npx skills@latest add JuliusBrussee/skills
* + see plans and rules in respctive folders

## Ollama + VS Code + Cline (free)

after Ollama install:
* ollama --version
* ollama serve // disable autostart in task mgr if wished

select model:
* page https://ollama.com/search?q=qwen
* start: ollama pull qwen3.5:9b
* (later: ollama pull qwen3.6:27b // or even newer version)
* ollama show qwen3.5:9b

run model (only needed for direct messages to the model):
* ollama run qwen3.5:9b

general ollama docs:
* page https://docs.ollama.com

after VS code Cline extension install:
* connect with cline account
* in cline extension settings => select ollama (if running downloaded model is already auto selected) 

## Ollama alternative setups

* ollama launch opencode
* try gemma4 model
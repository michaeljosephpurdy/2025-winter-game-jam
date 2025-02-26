local CoroutineResumingSystem = tiny.processingSystem()
function CoroutineResumingSystem:filter(e)
  return e.coroutine
end
function CoroutineResumingSystem:process(e, dt)
  coroutine.resume(e.coroutine)
end
return CoroutineResumingSystem

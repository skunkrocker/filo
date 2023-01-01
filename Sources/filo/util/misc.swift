
import Foundation

func waitOnQueue(onQueueAndSem: (DispatchQueue, DispatchSemaphore) -> Void) -> Void {
    let queue = DispatchQueue.global()
    let semaphore = DispatchSemaphore(value: 0)
    
    onQueueAndSem(queue, semaphore)
    
    semaphore.wait()
}


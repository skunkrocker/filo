
import Foundation

func waitOnQueue(onQueueAndSem: (DispatchQueue, @escaping () -> Void) -> Void) -> Void {
    let queue = DispatchQueue.global()
    let semaphore = DispatchSemaphore(value: 0)
    
    let stop: () -> () = {
       semaphore.signal()
       return ()
    }
    
    onQueueAndSem(queue, stop)
    
    semaphore.wait()
}

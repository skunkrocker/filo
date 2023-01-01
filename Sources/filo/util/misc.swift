
import Foundation

func waitOnQueue(onQueueAndSem: (DispatchQueue, @escaping () -> Void) -> Void) -> Void {
    let queue = DispatchQueue.global()
    let semaphore = DispatchSemaphore(value: 0)
    
    let stop: () -> () = {
       semaphore.signal()
       () //funny way to return void
    }
    
    onQueueAndSem(queue, stop)
    
    semaphore.wait()
}

func waitForAsync(theAsync: ( @escaping () -> Void) -> Void) {
    
    let semaphore = DispatchSemaphore(value: 0)
    
    let stop: () -> () = {
       semaphore.signal()
       return ()
    }
    
    theAsync(stop)
    
    semaphore.wait()
}

{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE QuasiQuotes #-}

module Main (main) where

import Control.Concurrent (forkIO, threadDelay)
import Control.Concurrent.Chan (Chan, newChan, readChan, writeChan)
import Control.Concurrent.QSem (QSem, newQSem, signalQSem, waitQSem)
import Control.Monad (forM_)
import Data.String.Interpolate (i)
import Data.Time.Clock (diffUTCTime, getCurrentTime)
import System.Environment (getArgs)

worker :: Chan Int -> QSem -> IO ()
worker chan sem = do
  writeChan chan 1
  threadDelay 1000000
  !_ <- readChan chan
  signalQSem sem

test :: Int -> IO ()
test n = do
  chan <- newChan
  sem <- newQSem 0
  forM_
    [1 .. n]
    ( \_ -> forkIO $! worker chan sem)
  forM_
    [1 .. n]
    ( \_ -> waitQSem sem)

main :: IO ()
main = do
  [s] <- getArgs
  let n = read s
  start <- getCurrentTime
  test n
  end <- getCurrentTime
  putStrLn [i|#{end `diffUTCTime` start} elapsed.|]

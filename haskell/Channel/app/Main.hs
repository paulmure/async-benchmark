{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE QuasiQuotes #-}

module Main (main) where

import Control.Concurrent (forkIO, threadDelay)
import Control.Concurrent.Chan (Chan, newChan, readChan, writeChan)
import Control.Monad (forM_)
import Data.String.Interpolate (i)
import Data.Time.Clock (diffUTCTime, getCurrentTime)
import System.Environment (getArgs)

worker :: Chan Int -> IO ()
worker chan = do
  threadDelay 1000000
  writeChan chan 1

test :: Int -> IO ()
test n = do
  chan <- newChan
  forM_
    [1 .. n]
    (\_ -> forkIO $! worker chan)
  forM_
    [1 .. n]
    (\_ -> readChan chan)

main :: IO ()
main = do
  [s] <- getArgs
  let n = read s
  start <- getCurrentTime
  test n
  end <- getCurrentTime
  putStrLn [i|#{end `diffUTCTime` start} elapsed.|]

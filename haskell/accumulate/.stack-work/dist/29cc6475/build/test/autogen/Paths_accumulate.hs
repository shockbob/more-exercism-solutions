{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_accumulate (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,3] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "C:\\Users\\shock\\Exercism\\haskell\\accumulate\\.stack-work\\install\\a6cba4d7\\bin"
libdir     = "C:\\Users\\shock\\Exercism\\haskell\\accumulate\\.stack-work\\install\\a6cba4d7\\lib\\x86_64-windows-ghc-8.8.4\\accumulate-0.1.0.3-6JUQdEBS631JQ0IoKFaEAF-test"
dynlibdir  = "C:\\Users\\shock\\Exercism\\haskell\\accumulate\\.stack-work\\install\\a6cba4d7\\lib\\x86_64-windows-ghc-8.8.4"
datadir    = "C:\\Users\\shock\\Exercism\\haskell\\accumulate\\.stack-work\\install\\a6cba4d7\\share\\x86_64-windows-ghc-8.8.4\\accumulate-0.1.0.3"
libexecdir = "C:\\Users\\shock\\Exercism\\haskell\\accumulate\\.stack-work\\install\\a6cba4d7\\libexec\\x86_64-windows-ghc-8.8.4\\accumulate-0.1.0.3"
sysconfdir = "C:\\Users\\shock\\Exercism\\haskell\\accumulate\\.stack-work\\install\\a6cba4d7\\etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "accumulate_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "accumulate_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "accumulate_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "accumulate_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "accumulate_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "accumulate_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "\\" ++ name)

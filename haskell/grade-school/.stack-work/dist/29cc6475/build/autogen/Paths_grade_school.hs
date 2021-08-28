{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_grade_school (
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
version = Version [1,0,0,4] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "C:\\Users\\shock\\Exercism\\haskell\\grade-school\\.stack-work\\install\\a6cba4d7\\bin"
libdir     = "C:\\Users\\shock\\Exercism\\haskell\\grade-school\\.stack-work\\install\\a6cba4d7\\lib\\x86_64-windows-ghc-8.8.4\\grade-school-1.0.0.4-BVGDvp7IZ6LCw3Cl1Xqvm5"
dynlibdir  = "C:\\Users\\shock\\Exercism\\haskell\\grade-school\\.stack-work\\install\\a6cba4d7\\lib\\x86_64-windows-ghc-8.8.4"
datadir    = "C:\\Users\\shock\\Exercism\\haskell\\grade-school\\.stack-work\\install\\a6cba4d7\\share\\x86_64-windows-ghc-8.8.4\\grade-school-1.0.0.4"
libexecdir = "C:\\Users\\shock\\Exercism\\haskell\\grade-school\\.stack-work\\install\\a6cba4d7\\libexec\\x86_64-windows-ghc-8.8.4\\grade-school-1.0.0.4"
sysconfdir = "C:\\Users\\shock\\Exercism\\haskell\\grade-school\\.stack-work\\install\\a6cba4d7\\etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "grade_school_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "grade_school_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "grade_school_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "grade_school_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "grade_school_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "grade_school_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "\\" ++ name)

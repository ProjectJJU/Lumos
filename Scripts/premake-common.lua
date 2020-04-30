newoption 
{
   trigger     = "renderer",
   value       = "API",
   description = "Choose a renderer",
   allowed = 
   {
      { "opengl", "OpenGL (macOS, linux, Windows)" },
      --{ "dx11",  "DirectX 11 (Windows only)" },
      --{ "metal", "Metal (macOS, iOS only)" },
      { "vulkan", "Vulkan (Windows, linux, iOS, macOS)" }
   }
}

newoption
{
	trigger = "arch",
	value   = "arch",
	description = "Choose architecture",
	allowed = 
	{
		{"x86", "x86" },
		{"x64", "x64" },
		{"arm", "arm" },
		{"arm64", "arm64"}
	}
}

newoption 
{
   trigger     = "xcode_target",
   value       = "TARGET",
   description = "Choose an xcode build target",
   allowed = 
   {
      { "osx", "OSX" },
      { "ios",  "iOS" },
      { "tvOS", "TVOS" },
   }
}

newoption
{
	trigger     = "teamid",
	value	    = "id",
	description = "development team id for apple developers"
}

function SetRecommendedXcodeSettings()
   xcodebuildsettings
   {
		['ARCHS'] = false,
		['GCC_ENABLE_FIX_AND_CONTIUE'] = false,
	  	['CLANG_WARN_EMPTY_BODY'] = 'YES',
	  	['CLANG_ENABLE_OBJC_WEAK'] = 'YES',
	  	['GCC_WARN_UNUSED_FUNCTION'] = 'YES',
	  	['GCC_WARN_UNINITIALIZED_AUTOS'] = 'YES',
	  	['ENABLE_STRICT_OBJC_MSGSEND'] = 'YES',
	  	['CLANG_WARN_BOOL_CONVERSION'] = 'YES',
	  	['CLANG_WARN_UNREACHABLE_CODE'] = 'YES',
	  	['CLANG_WARN_CONSTANT_CONVERSION'] = 'YES',
	  	['GCC_WARN_64_TO_32_BIT_CONVERSION'] = 'YES',
	  	['PRECOMPS_INCLUDE_HEADERS_FROM_BUILT_PRODUCTS_DIR'] = 'YES',
		['SCAN_ALL_SOURCE_FILES_FOR_INCLUDES'] = 'NO',
		['GCC_WARN_MISSING_PARENTHESES'] = 'NO',
		['GCC_WARN_CHECK_SWITCH_STATEMENTS'] = 'NO',
		['GCC_AUTO_VECTORIZATION'] = 'NO',
		['GCC_OBJC_CALL_CXX_CDTORS'] = 'NO',
		['GCC_STRICT_ALIASING'] = 'NO',
		['GCC_FEEDBACK_DIRECTED_OPTIMIZATION'] = 'OFF',
		['GCC_GENERATE_DEBUGGING_SYMBOLS'] = 'YES',
		['GCC_DYNAMIC_NO_PIC'] = 'NO',
		['GCC_GENERATE_TEST_COVERAGE_FILES'] = 'NO',
		['GCC_INLINES_ARE_PRIVATE_EXTERN'] = 'NO',
		['GCC_MODEL_TUNING'] = 'G4',
		['GCC_INSTRUMENT_PROGRAM_FLOW_ARCS'] = 'NO',
		['GCC_ENABLE_KERNEL_DEVELOPMENT'] = 'NO',
		['GCC_DEBUGGING_SYMBOLS'] = 'default',
		['GCC_REUSE_STRINGS'] = 'YES',
		['GCC_NO_COMMON_BLOCKS'] = 'NO',
		['GCC_FAST_MATH'] = 'YES',
		['GCC_ENABLE_SYMBOL_SEPARATION'] = 'YES',
		['GCC_THREADSAFE_STATICS'] = 'YES',
		['GCC_SYMBOLS_PRIVATE_EXTERN'] = 'NO',
		['GCC_UNROLL_LOOPS'] = 'NO',
		['GCC_MODEL_PPC64'] = 'NO',
		['GCC_CHAR_IS_UNSIGNED_CHAR'] = 'NO',
		['GCC_ENABLE_ASM_KEYWORD'] = 'YES',
		['GCC_CHECK_RETURN_VALUE_OF_OPERATOR_NEW'] = 'NO',
		['GCC_CW_ASM_SYNTAX'] = 'YES',
		['GCC_INPUT_FILETYPE'] = 'automatic',
		['GCC_ALTIVEC_EXTENSIONS'] = 'NO',
		['GCC_ENABLE_TRIGRAPHS'] = 'NO',
		['GCC_ENABLE_FLOATING_POINT_LIBRARY_CALLS'] = 'NO',
		['GCC_INCREASE_PRECOMPILED_HEADER_SHARING'] = 'NO',
		['GCC_ENABLE_BUILTIN_FUNCTIONS'] = 'YES',
		['GCC_ENABLE_PASCAL_STRINGS'] = 'YES',
		['GCC_FORCE_CPU_SUBTYPE_ALL'] = 'NO',
		['GCC_SHORT_ENUMS'] = 'NO',
		['GCC_USE_GCC3_PFE_SUPPORT'] = 'YES',
		['GCC_ONE_BYTE_BOOL'] = 'YES',
		['GCC_USE_STANDARD_INCLUDE_SEARCHING'] = 'YES',
		['GCC_WARN_ABOUT_RETURN_TYPE'] = 'YES',
		['GCC_WARN_ABOUT_POINTER_SIGNEDNESS'] = 'YES',
		['GCC_WARN_UNUSED_VARIABLE'] = 'NO',
		['CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING'] = 'YES',
		['CLANG_WARN_BOOL_CONVERSION'] = 'YES',
		['CLANG_WARN_COMMA'] = 'NO',
		['CLANG_WARN_CONSTANT_CONVERSION'] = 'YES',
		['CLANG_WARN_EMPTY_BODY'] = 'YES',
		['CLANG_WARN_ENUM_CONVERSION'] = 'YES',
		['CLANG_WARN_INFINITE_RECURSION'] = 'YES',
		['CLANG_WARN_INT_CONVERSION'] = 'YES',
		['CLANG_WARN_NON_LITERAL_NULL_CONVERSION'] = 'YES',
		['CLANG_WARN_OBJC_LITERAL_CONVERSION'] = 'YES',
		['CLANG_WARN_RANGE_LOOP_ANALYSIS'] = 'YES',
		['CLANG_WARN_STRICT_PROTOTYPES'] = 'YES',
		['CLANG_WARN_SUSPICIOUS_MOVE'] = 'YES',
		['CLANG_WARN__DUPLICATE_METHOD_MATCH'] = 'YES',
		['ENABLE_STRICT_OBJC_MSGSEND'] = 'YES',
		['GCC_WARN_UNDECLARED_SELECTOR'] = 'YES',
	  	['CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF'] = 'YES',
	  	['CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS'] = 'YES'
   }

   filter {"system:macosx or system:ios", "configurations:debug"}
        xcodebuildsettings
    	{
			['ENABLE_TESTABILITY'] = 'YES',
			['ONLY_ACTIVE_ARCH'] = 'YES'
	    }
end

function SetRecommendedSettings()

	filter ()
	filter {"system:macosx or system:ios"}
		SetRecommendedXcodeSettings()
	filter ()
	editandcontinue "Off"
	warnings "Off"
	
end

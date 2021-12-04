#include "Precompiled.h"
#include "EmbedAsset.h"
#include "Graphics/RHI/Texture.h"
#include "Graphics/RHI/Shader.h"
#include "Core/OS/FileSystem.h"
#include "Core/StringUtilities.h"
#include "Utilities/LoadImage.h"

#include <iomanip>

namespace Lumos
{
	void EmbedTexture(const std::string& texFilePath, const std::string& outPath, const std::string& arrayName)
	{
        uint32_t width, height, bits;
        bool isHDR;
        auto texture = LoadImageFromFile(texFilePath.c_str(), &width, &height, &bits, &isHDR);
		
        size_t psize = width * height * 4;
        std::ofstream file;
        file.open(outPath);
        file << "//Generated by Lumos using " << texFilePath << std::endl;
        file << "static const uint32_t " << arrayName << "Width = " << width << ";" << std::endl;
        file << "static const uint32_t " << arrayName << "Height = " << height << ";" << std::endl;
        file << "static const uint8_t " << arrayName << "[] = {" << (int)texture[0];
        for(size_t i = 1; i < psize; ++i)
            file << "," << (int)texture[i];
        file << "};";
		
        file.close();
    }
	
	
	void EmbedShader(const std::string& shaderPath)
	{
        //Based on https://github.com/StableCoder/vksbc
		
        uint32_t* data = reinterpret_cast<uint32_t*>(FileSystem::ReadFile(shaderPath));
        uint32_t size = uint32_t(FileSystem::GetFileSize(shaderPath));
		
        if(!data)
        {
            LUMOS_LOG_WARN("Failed to load shader : {0}", shaderPath);
            return;
        }
        auto shaderPath2 = shaderPath;
        shaderPath2 = StringUtilities::BackSlashesToSlashes(shaderPath2);
		
        std::string shaderName = StringUtilities::GetFileName(shaderPath2);
        shaderName = StringUtilities::RemoveFilePathExtension(shaderName);
        shaderName = StringUtilities::RemoveSpaces(shaderName);
        shaderName = StringUtilities::RemoveCharacter(shaderName, '.');
        shaderName = StringUtilities::RemoveCharacter(shaderName, '_');
		
        std::string extension = StringUtilities::GetFilePathExtension(shaderPath2);
        shaderName = shaderName + extension;
		
        std::stringstream ss;
        ss << "// Header generated by Lumos Editor\n\n";
        ss << "#include <array>\n";
        ss << "#include <cstdint>\n\n";
		
        ss << "constexpr uint32_t spirv_" << shaderName << "_size = " << size << ";\n";
        ss << "constexpr std::array<uint32_t, " << (size / 4) << "> spirv_" << shaderName
			<< " = {\n    ";
		
        int currentWidth = 0;
        for(unsigned int i = 0; i < size / 4; ++i)
        {
            // Convert the 4-bytes into a 0x00000000 hexadecimal representation.
            ss << "0x" << std::hex << std::setw(sizeof(uint32_t) * 8 / 4) << std::uppercase
				<< std::setfill('0') << data[i] << ", ";
			
            ++currentWidth;
			
            // Newline after certain number of items.
            if(currentWidth == 8)
            {
                currentWidth = 0;
                ss << "\n";
            }
        }
		
        ss << "\n    };";
		
        std::string folder = StringUtilities::GetFileLocation(shaderPath2);
        shaderName = StringUtilities::BackSlashesToSlashes(shaderName);
        FileSystem::WriteTextFile(folder + "Headers/" + shaderName + ".hpp", ss.str());
    }
}

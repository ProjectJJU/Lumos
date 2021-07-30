#pragma once
#include "Graphics/RHI/DescriptorSet.h"
#include "VK.h"

namespace Lumos
{
    namespace Graphics
    {
        class VKDescriptorSet : public DescriptorSet
        {
        public:
            VKDescriptorSet(const DescriptorDesc& info);
            ~VKDescriptorSet();

            VkDescriptorSet GetDescriptorSet() const { return m_DescriptorSet; }
            void Update() override;
            void SetTexture(const std::string& name, Texture* texture, TextureType textureType) override;
            void SetTexture(const std::string& name, Texture** texture, uint32_t textureCount, TextureType textureType) override;
            void SetBuffer(const std::string& name, UniformBuffer* buffer) override;
            
            bool GetIsDynamic() const { return m_Dynamic; }

            void SetDynamicOffset(uint32_t offset) override { m_DynamicOffset = offset; }
            uint32_t GetDynamicOffset() const override { return m_DynamicOffset; }

            static void MakeDefault();

        protected:
            void UpdateInternal(std::vector<Descriptor>* imageInfos);

            static DescriptorSet* CreateFuncVulkan(const DescriptorDesc&);

        private:
            VkDescriptorSet m_DescriptorSet;
            uint32_t m_DynamicOffset = 0;
            Shader* m_Shader = nullptr;
            bool m_Dynamic = false;
            VkDescriptorBufferInfo* m_BufferInfoPool = nullptr;
            VkDescriptorImageInfo* m_ImageInfoPool = nullptr;
            VkWriteDescriptorSet* m_WriteDescriptorSetPool = nullptr;

            DescriptorSetInfo m_Descriptors;
        };
    }
}

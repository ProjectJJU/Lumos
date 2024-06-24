#ifndef LUMOS_PLATFORM_MACOS
#include "Precompiled.h"
#endif
#include "Timer.h"

namespace Lumos
{

    float Timer::GetTimedMS()
    {
        float time = Duration(m_LastTime, Now(), 1000.0f);
        m_LastTime = Now();
        return time;
    }

}
